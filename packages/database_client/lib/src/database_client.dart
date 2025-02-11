import 'package:powersync_repository/powersync_repository.dart' hide User;
import 'package:user_repository/user_repository.dart';

/// UserBaseRepository
abstract class UserBaseRepository {
  /// Returns the current authenticated user's id.
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

  /// Returns a list of friends for the user identified by [userId].
  Future<List<User>> getFriends({required String userId});

  /// Unfriends the user identified by [friendId].
  Future<void> unfriend({required String userId, required String friendId});
}

/// {@template database_client}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
abstract class DatabaseClient implements UserBaseRepository {
  /// {@macro database_client}
  const DatabaseClient();
}

/// PowerSyncDatabaseClient
class PowerSyncDatabaseClient extends DatabaseClient {
  /// {@macro power_sync_database_client}
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

  @override
  Future<List<User>> getFriends({required String userId}) async {
    final listFriendships = await _powerSyncRepository.db().getAll(
      '''
      SELECT * FROM friendships WHERE (sender_id = ? OR receiver_id = ?)
      ''',
      [userId, userId],
    );
    if (listFriendships.isEmpty) return [];
    final friends = <User>[];
    for (final friendship in listFriendships) {
      final friendId = friendship['sender_id'] == userId
          ? friendship['receiver_id']
          : friendship['sender_id'];
      final result = await _powerSyncRepository.db().execute(
        '''
        SELECT * FROM users WHERE id = ?
        ''',
        [friendId],
      );
      if (result.isEmpty) continue;
      final friend = User.fromJson(result.first);
      friends.add(friend);
    }
    return friends;
  }

  @override
  Future<void> unfriend({
    required String userId,
    required String friendId,
  }) async {
    await _powerSyncRepository.db().execute(
      '''
      DELETE FROM friendships WHERE (sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)
      ''',
      [userId, friendId, friendId, userId],
    );
  }
}
