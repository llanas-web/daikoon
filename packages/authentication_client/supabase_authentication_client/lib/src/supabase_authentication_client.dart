import 'dart:convert';
import 'dart:io';

import 'package:authentication_client/authentication_client.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:powersync_repository/powersync_repository.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:token_storage/token_storage.dart';

/// {@template supabase_authentication_client}
/// A Supabase implementation of the [AuthenticationClient] interface.
/// {@endtemplate}
class SupabaseAuthenticationClient implements AuthenticationClient {
  /// {@macro supabase_authentication_client}
  SupabaseAuthenticationClient({
    required PowerSyncRepository powerSyncRepository,
    required TokenStorage tokenStorage,
    required GoogleSignIn googleSignIn,
  })  : _tokenStorage = tokenStorage,
        _powerSyncRepository = powerSyncRepository,
        _googleSignIn = googleSignIn {
    user.listen(_onUserChanged);
  }

  final TokenStorage _tokenStorage;
  final PowerSyncRepository _powerSyncRepository;
  final GoogleSignIn _googleSignIn;

  /// Stream of [AuthenticationUser] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [AuthenticationUser.anonymous] if the user is not authenticated.
  @override
  Stream<AuthenticationUser> get user {
    return _powerSyncRepository.authStateChanges().map((state) {
      final supabaseUser = state.session?.user;
      return supabaseUser == null
          ? AuthenticationUser.anonymous
          : supabaseUser.toUser;
    });
  }

  @override
  Future<void> logInWithPassword({
    required String password,
    String? email,
    String? phone,
  }) async {
    try {
      if (email == null && phone == null) {
        throw const LogInWithPasswordCanceled(
          'You must provide either an email, phone number.',
        );
      }
      await _powerSyncRepository.supabase.auth
          .signInWithPassword(email: email, phone: phone, password: password);
    } on LogInWithPasswordCanceled {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithPasswordFailure(error), stackTrace);
    }
  }

  /// Starts the Sign In with Google Flow.
  ///
  /// Throws a [LogInWithGoogleCanceled] if the flow is canceled by the user.
  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  @override
  Future<void> logInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw const LogInWithGoogleCanceled(
          'Sign in with Google canceled. No user found!',
        );
      }
      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;
      if (accessToken == null) {
        throw const LogInWithGoogleFailure('No Access Token found.');
      }
      if (idToken == null) {
        throw const LogInWithGoogleFailure('No ID Token found.');
      }

      await _powerSyncRepository.supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } on LogInWithGoogleCanceled {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithGoogleFailure(error), stackTrace);
    }
  }

  @override
  Future<void> logInWithApple() async {
    if (Platform.isIOS) {
      await logInWithAppleIos();
    } else {
      await _powerSyncRepository.supabase.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: kIsWeb ? null : 'my.scheme://my-host',
        // Optionally set the redirect link to bring back the user via deeplink.
        authScreenLaunchMode: kIsWeb
            ? LaunchMode.platformDefault
            : LaunchMode.externalApplication,
        // Launch the auth screen in a new webview on mobile.
      );
    }
  }

  /// iOS specific implementation of Sign In with Apple.
  Future<void> logInWithAppleIos() async {
    final rawNonce = _powerSyncRepository.supabase.auth.generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    final idToken = credential.identityToken;
    if (idToken == null) {
      throw const LogInWithAppleFailure('No ID Token found.');
    }

    await _powerSyncRepository.supabase.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      accessToken: credential.authorizationCode,
    );
  }

  @override
  Future<void> signUpWithPassword({
    required String password,
    required String username,
    String? email,
    String? phone,
    String? pushToken,
  }) async {
    final data = {
      'username': username,
      if (pushToken != null) 'push_token': pushToken,
    };
    try {
      await _powerSyncRepository.supabase.auth.signUp(
        email: email,
        phone: phone,
        password: password,
        data: data,
        emailRedirectTo: kIsWeb
            ? null
            : 'io._powerSyncRepository.supabase.flutterquickstart://login-callback/',
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SignUpWithPasswordFailure(error), stackTrace);
    }
  }

  @override
  Future<void> sendPasswordResetEmail({
    required String email,
    String? redirectTo,
  }) async {
    try {
      await _powerSyncRepository.resetPassword(
        email: email,
        redirectTo: redirectTo,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        SendPasswordResetEmailFailure(error),
        stackTrace,
      );
    }
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String email,
    required String newPassword,
  }) async {
    try {
      await _powerSyncRepository.verifyOTP(
        token: token,
        email: email,
        type: OtpType.recovery,
      );
      await _powerSyncRepository.updateUser(password: newPassword);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ResetPasswordFailure(error), stackTrace);
    }
  }

  @override
  Future<void> verifyOtp({required String email, required String otp}) {
    try {
      return _powerSyncRepository.verifyOTP(
        token: otp,
        email: email,
        type: OtpType.signup,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(VerifyOtpFailure(error), stackTrace);
    }
  }

  /// Signs out the current user which will emit
  /// [AuthenticationUser.anonymous] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  @override
  Future<void> logOut() async {
    try {
      await _powerSyncRepository.db().disconnectAndClear();
      await _powerSyncRepository.supabase.auth.updateUser(
        UserAttributes(
          data: {'push_token': null},
        ),
      );
      await _powerSyncRepository.supabase.auth.signOut();
      await _googleSignIn.signOut();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogOutFailure(error), stackTrace);
    }
  }

  /// Updates the user token in [TokenStorage] if the user is authenticated.
  Future<void> _onUserChanged(AuthenticationUser user) async {
    if (!user.isAnonymous) {
      await _tokenStorage.saveToken(user.id);
    } else {
      await _tokenStorage.clearToken();
    }
  }
}

extension on supabase.User {
  AuthenticationUser get toUser {
    return AuthenticationUser(
      id: id,
      email: email,
      fullName: userMetadata?['full_name'] as String?,
      username: userMetadata?['username'] as String?,
      avatarUrl: userMetadata?['avatar_url'] as String?,
      pushToken: userMetadata?['push_token'] as String?,
      isNewUser: createdAt == lastSignInAt,
    );
  }
}
