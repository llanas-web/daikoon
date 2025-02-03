import 'package:daikoon/app/app.dart';
import 'package:env/env.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:powersync_repository/powersync_repository.dart';
import 'package:shared/shared.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GoogleSignInButton(),
              LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  Future<void> _googleSignIn() async {
    final webClientId = getIt<AppFlavor>().getEnv(Env.webClientId);
    final iOSClientId = getIt<AppFlavor>().getEnv(Env.iOSClientId);

    final googleSignIn =
        GoogleSignIn(clientId: iOSClientId, serverClientId: webClientId);

    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser?.authentication;

    if (googleAuth == null) {
      throw Exception('Google sign in was cancelled');
    }

    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw Exception('No access token found');
    }
    if (idToken == null) {
      throw Exception('No id token found');
    }

    await Supabase.instance.client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        try {
          await _googleSignIn();
        } catch (error, stackTrace) {
          logE(
            'Failed to login with Google.',
            error: error,
            stackTrace: stackTrace,
          );
        }
      },
      icon: const Icon(Icons.auto_awesome),
      label: Text(
        'Google Sign In',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  void _logout() => Supabase.instance.client.auth.signOut();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final session = snapshot.data!.session;
          if (session == null) {
            return const SizedBox.shrink();
          }
          return ElevatedButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            label: Text(
              'Logout',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.apply(color: Colors.red),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
