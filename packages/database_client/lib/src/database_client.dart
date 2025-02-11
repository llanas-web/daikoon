import 'package:powersync_repository/powersync_repository.dart' hide User;
import 'package:user_repository/user_repository.dart';

abstract class UserBaseRepository {
  String? get currentUserId;

  /// Broadcasts the user profile identified by [userId].
  Stream<User> profile({required String userId});

  /// Updates currently authenticated database user's metadata.
  Future<void> updateUser({
    String? fullName,
    String? email,
    String? username,
    String? avatarUrl,
    String? pushToken,
  });

  /// Broadcasts the user's daikoins amount identified by [userId].
  Stream<int> daikoins({required String userId});
}

/// {@template database_client}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
abstract class DatabaseClient implements UserBaseRepository {
  /// {@macro database_client}
  const DatabaseClient();
}

class PowerSyncDatabaseClient extends DatabaseClient {
  const PowerSyncDatabaseClient({
    required PowerSyncRepository powerSyncRepository,
  }) : _powerSyncRepository = powerSyncRepository;

  final PowerSyncRepository _powerSyncRepository;

  @override
  String? get currentUserId =>
      _powerSyncRepository.supabase.auth.currentSession?.user.id;

  @override
  Stream<User> profile({required String userId}) =>
      _powerSyncRepository.db().watch(
        '''
        SELECT * FROM users WHERE id = ?
        ''',
        parameters: [userId],
      ).map(
        (event) => event.isEmpty ? User.anonymous : User.fromJson(event.first),
      );

  @override
  Future<void> updateUser({
    String? fullName,
    String? email,
    String? username,
    String? avatarUrl,
    String? pushToken,
    String? password,
  }) =>
      _powerSyncRepository.updateUser(
        email: email,
        password: password,
        data: {
          if (fullName != null) 'full_name': fullName,
          if (username != null) 'username': username,
          if (avatarUrl != null) 'avatar_url': avatarUrl,
          if (pushToken != null) 'push_token': pushToken,
        },
      );

  @override
  Stream<int> daikoins({required String userId}) =>
      _powerSyncRepository.db().watch(
        '''
        SELECT * FROM wallets WHERE user_id = ?
        ''',
        parameters: [userId],
      ).map(
        (event) => event.isEmpty ? 0 : event.first['amount'] as int,
      );
}
