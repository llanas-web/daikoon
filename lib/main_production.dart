import 'package:challenge_repository/challenge_repository.dart';
import 'package:daikoon/app/app.dart';
import 'package:daikoon/bootstrap.dart';
import 'package:daikoon/firebase_options_prod.dart';
import 'package:database_client/database_client.dart';
import 'package:env/env.dart';
import 'package:firebase_notifications_client/firebase_notifications_client.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:shared/shared.dart';
import 'package:supabase_authentication_client/supabase_authentication_client.dart';
import 'package:token_storage/token_storage.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  bootstrap(
    (powerSyncrepository, firebaseMessaging) async {
      final iOSClientId = getIt<AppFlavor>().getEnv(Env.iOSClientId);
      final webClientId = getIt<AppFlavor>().getEnv(Env.webClientId);

      final tokenStorage = InMemoryTokenStorage();
      final googleSignIn = GoogleSignIn(
        clientId: iOSClientId,
        serverClientId: webClientId,
      );

      final authenticationClient = SupabaseAuthenticationClient(
        powerSyncRepository: powerSyncrepository,
        tokenStorage: tokenStorage,
        googleSignIn: googleSignIn,
      );

      final powerSyncDatabaseClient = PowerSyncDatabaseClient(
        powerSyncRepository: powerSyncrepository,
      );

      final userRepository = UserRepository(
        authenticationClient: authenticationClient,
        databaseClient: powerSyncDatabaseClient,
      );

      final challengeRepository = ChallengeRepository(
        databaseClient: powerSyncDatabaseClient,
      );

      final firebaseNotificationsClient = FirebaseNotificationsClient(
        firebaseMessaging: firebaseMessaging,
      );

      final notificationsRepository = NotificationsRepository(
        databaseClient: powerSyncDatabaseClient,
        notificationsClient: firebaseNotificationsClient,
      );

      return App(
        user: await userRepository.user.first,
        userRepository: userRepository,
        challengeRepository: challengeRepository,
        notificationsRepository: notificationsRepository,
      );
    },
    options: DefaultFirebaseOptions.currentPlatform,
    appFlavor: AppFlavor.production(),
  );
}
