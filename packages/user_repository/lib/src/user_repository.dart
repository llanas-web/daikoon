import 'package:authentication_client/authentication_client.dart';
import 'package:database_client/database_client.dart';
// import 'package:powersync_repository/powersync_repository.dart' hide User;
import 'package:user_repository/user_repository.dart';

/// {@template user_repository}
/// A package that manages user flow.
/// {@endtemplate}
class UserRepository implements UserBaseRepository {
  /// {@macro user_repository}
  const UserRepository({
    required AuthenticationClient authenticationClient,
    required DatabaseClient databaseClient,
  })  : _authenticationClient = authenticationClient,
        _databalseClient = databaseClient;

  final AuthenticationClient _authenticationClient;
  final DatabaseClient _databalseClient;

  @override
  String? get currentUserId => _databalseClient.currentUserId;

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  Stream<User> get user => _authenticationClient.user
      .map((user) => User.fromAuthenticationUser(authenticationUser: user))
      .asBroadcastStream();

  /// Starts the Sign In with Google Flow.
  ///
  /// Throws a [LogInWithGoogleCanceled] if the flow is canceled by the user.
  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  Future<void> logInWithGoogle() async {
    try {
      await _authenticationClient.logInWithGoogle();
    } on LogInWithGoogleFailure {
      rethrow;
    } on LogInWithGoogleCanceled {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithGoogleFailure(error), stackTrace);
    }
  }

  /// Signs out the current user which will emit
  /// [User.anonymous] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      await _authenticationClient.logOut();
    } on LogOutFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogOutFailure(error), stackTrace);
    }
  }

  /// Logins in with the provided [password].
  Future<void> logInWithPassword({
    required String password,
    String? email,
    String? phone,
  }) async {
    try {
      await _authenticationClient.logInWithPassword(
        email: email,
        phone: phone,
        password: password,
      );
    } on LogInWithPasswordFailure {
      rethrow;
    } on LogInWithPasswordCanceled {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithPasswordFailure(error), stackTrace);
    }
  }

  /// Sign up with the provided [password].
  Future<void> signUpWithPassword({
    required String password,
    required String username,
    String? email,
    String? phone,
    String? pushToken,
  }) async {
    try {
      await _authenticationClient.signUpWithPassword(
        email: email,
        phone: phone,
        password: password,
        username: username,
        pushToken: pushToken,
      );
    } on SignUpWithPasswordFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SignUpWithPasswordFailure(error), stackTrace);
    }
  }

  /// Sends a password reset email to the provided [email].
  /// Optionally allows specifying a [redirectTo] url to redirect
  /// the user to after resetting their password.
  Future<void> sendPasswordResetEmail({
    required String email,
    String? redirectTo,
  }) async {
    try {
      await _authenticationClient.sendPasswordResetEmail(
        email: email,
        redirectTo: redirectTo,
      );
    } on SendPasswordResetEmailFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        SendPasswordResetEmailFailure(error),
        stackTrace,
      );
    }
  }

  /// Resets the password for the user with the given [email]
  /// using the provided [token]. Updates the password to
  /// the new [newPassword].
  Future<void> resetPassword({
    required String token,
    required String email,
    required String newPassword,
  }) async {
    try {
      await _authenticationClient.resetPassword(
        token: token,
        email: email,
        newPassword: newPassword,
      );
    } on ResetPasswordFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ResetPasswordFailure, stackTrace);
    }
  }

  @override
  Stream<User> profile({required String userId}) =>
      _databalseClient.profile(userId: userId);
}
