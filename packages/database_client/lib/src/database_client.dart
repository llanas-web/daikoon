import 'package:powersync_repository/powersync_repository.dart' hide User;
import 'package:shared/shared.dart';
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

  /// Returns realtime stream of friends for the user identified by [userId].
  Stream<List<User>> getFriends({required String userId});

  /// Returns realtime stream of friendships status of the user identified by
  /// [friendId] to the user identified by [userId].
  Stream<bool> friendshipStatus({
    required String friendId,
    String? userId,
  });

  /// Adds a friend identified by [friendId]. [userId] is the id
  /// of currently authenticated user.
  Future<void> addFriend({
    required String friendId,
    String? userId,
  });

  /// Remove friend the user identified by [friendId]. [userId] is the id
  /// of currently authenticated user.
  Future<void> removeFriend({
    required String friendId,
    String? userId,
  });

  /// Looks up into a database a returns users associated with the provided
  /// [query].
  Future<List<User>> searchUsers({
    required int limit,
    required int offset,
    required String query,
    String? userId,
    String? excludeUserIds,
  });

  /// Search for friends associated with the provided [userId] and [query].
  Future<List<User>> searchFriends({
    required String query,
    String? userId,
  });
}

/// ChallengeBaseRepository
// ignore: one_member_abstracts
abstract class ChallengeBaseRepository {
  /// Creates a challenge.
  Future<void> createChallenge({
    required Challenge challenge,
    required User creator,
    List<Choice> choices,
    List<Participant> participants,
  });
}

/// {@template database_client}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
abstract class DatabaseClient
    implements UserBaseRepository, ChallengeBaseRepository {
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
  Stream<List<User>> getFriends({required String userId}) {
    return _powerSyncRepository.db().watch(
      '''
      SELECT users.id, users.username, users.full_name, users.avatar_url
      FROM friendships
      JOIN users
      ON (friendships.receiver_id = users.id OR friendships.sender_id = users.id) AND users.id != ?1
      WHERE (friendships.sender_id = ?1 OR friendships.receiver_id = ?1)
      ''',
      parameters: [userId],
    ).map(
      (event) => event.safeMap(User.fromJson).toList(growable: false),
    );
  }

  @override
  Future<void> removeFriend({
    required String friendId,
    String? userId,
  }) async {
    await _powerSyncRepository.db().execute(
      '''
      DELETE FROM friendships WHERE (sender_id = ?1 AND receiver_id = ?2) OR (sender_id = ?2 AND receiver_id = ?1)
      ''',
      [userId ?? currentUserId, friendId],
    );
  }

  @override
  Stream<bool> friendshipStatus({
    required String friendId,
    String? userId,
  }) =>
      _powerSyncRepository.db().watch(
        '''
        SELECT 1 FROM friendships WHERE (sender_id = ?1 AND receiver_id = ?2) OR (sender_id = ?2 AND receiver_id = ?1)
        ''',
        parameters: [userId ?? currentUserId, friendId],
      ).map((event) => event.isNotEmpty);

  @override
  Future<List<User>> searchUsers({
    required int limit,
    required int offset,
    required String query,
    String? userId,
    String? excludeUserIds,
  }) async {
    final excludeUserIdsStatement =
        excludeUserIds == null ? '' : 'AND id NOT IN ($excludeUserIds)';
    final result = await _powerSyncRepository.db().getAll(
      '''
      SELECT id, avatar_url, full_name, username 
      FROM users 
      WHERE (LOWER(username) LIKE LOWER('%$query%') OR LOWER(full_name) LIKE LOWER('%$query%'))
      AND id <> ?1 $excludeUserIdsStatement
      LIMIT ?2 OFFSET ?3
      ''',
      [currentUserId, limit, offset],
    );
    return result.safeMap(User.fromJson).toList(growable: false);
  }

  @override
  Future<void> addFriend({
    required String friendId,
    String? userId,
  }) async {
    final senderId = userId ?? currentUserId;
    await _powerSyncRepository.db().execute(
      '''
      INSERT INTO friendships (id, sender_id, receiver_id) VALUES ('$senderId.$friendId', ?1, ?2)
      ''',
      [senderId, friendId],
    );
  }

  @override
  Future<List<User>> searchFriends({required String query, String? userId}) {
    return _powerSyncRepository.db().getAll(
      '''
      SELECT users.id, users.username, users.full_name, users.avatar_url
      FROM friendships
      JOIN users
      ON (friendships.receiver_id = users.id OR friendships.sender_id = users.id) AND users.id != ?1
      WHERE (friendships.sender_id = ?1 OR friendships.receiver_id = ?1)
      AND (LOWER(users.username) LIKE LOWER('%$query%') OR LOWER(users.full_name) LIKE LOWER('%$query%'))
      ''',
      [userId ?? currentUserId],
    ).then((event) => event.safeMap(User.fromJson).toList(growable: false));
  }

  @override
  Future<void> createChallenge({
    required Challenge challenge,
    required User creator,
    List<Choice> choices = const [],
    List<Participant> participants = const [],
  }) async {
    await _powerSyncRepository.db().writeTransaction((sqlContext) async {
      await sqlContext.execute(
        '''
        INSERT INTO challenges (id, title, question, starting, limit_date, ending, min_bet, max_bet, has_bet, creator_id)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''',
        [
          challenge.id,
          challenge.title,
          challenge.question,
          challenge.starting!.toIso8601String(),
          challenge.limitDate!.toIso8601String(),
          challenge.ending!.toIso8601String(),
          challenge.minBet,
          challenge.maxBet,
          challenge.hasBet,
          creator.id,
        ],
      );

      for (final choice in choices) {
        await sqlContext.execute(
          '''
          INSERT INTO choices (id, value, challenge_id, is_correct)
          VALUES (?, ?, ?, ?)
          ''',
          [choice.id, choice.value, challenge.id, choice.isCorrect],
        );
      }

      await sqlContext.execute(
        '''
          INSERT INTO participants (id, challenge_id, user_id, status)
          VALUES (?, ?, ?, ?)
          ''',
        [
          '${challenge.id}.${creator.id}',
          challenge.id,
          creator.id,
          ParticipantStatus.accepted.name,
        ],
      );

      for (final participant in participants) {
        await sqlContext.execute(
          '''
          INSERT INTO participants (id, challenge_id, user_id, status)
          VALUES (?, ?, ?, ?)
          ''',
          [
            '${challenge.id}.${participant.id}',
            challenge.id,
            participant.id,
            participant.status.name,
          ],
        );
      }
    });
  }
}
