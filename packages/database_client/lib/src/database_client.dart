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
    List<String>? excludeUserIds,
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

  /// Returns a list of challenges associated with the provided [userId].
  Stream<List<Challenge>> getChallenges({required String userId});

  /// Returns the challenge details associated with the provided [challengeId].
  Future<Challenge> getChallengeDetails({required String challengeId});

  /// Returns the challenge participants
  /// associated with the provided [challengeId].
  Future<List<Participant>> getParticipants({required String challengeId});

  /// Returns the challenge participants
  /// associated with the provided [challengeId].
  Stream<List<Participant>> fetchChallengeParticipant({
    required String challengeId,
  });

  /// Returns the challenge Bets
  /// associated with the provided [challengeId].
  Future<List<Bet>> getBets({required String challengeId});

  /// Returns the challenge bets associated with the provided [challengeId].
  Stream<List<Bet>> fetchChallengeBets({required String challengeId});

  /// Updates a bet associated with the provided [bet].
  Future<Bet> upsertBet({required Bet bet});

  /// Updates the participant associated with the provided [participant].
  Future<Participant> updateParticipant({
    required Participant participant,
  });

  /// Updates the choice associated with the provided [choice].
  Future<Choice> updateChoice({required Choice choice});

  /// Get the award received from [betId] by a [userId].
  Future<int> getAward({required String betId, required String userId});
}

/// NotificationBaseRepository
// ignore: one_member_abstracts
abstract class NotificationBaseRepository {
  /// Returns a list of notifications associated with the provided [userId].
  Stream<List<Notification>> notificationsOf({required String userId});

  /// Marks the notification with the provided [notificationId] as checked.
  Future<void> markAsChecked(String notificationId);
}

/// {@template database_client}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
abstract class DatabaseClient
    implements
        UserBaseRepository,
        ChallengeBaseRepository,
        NotificationBaseRepository {
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
  Future<List<User>> searchFriends({
    required String query,
    String? userId,
    List<String>? excludeUserIds,
  }) {
    final excludeUserIdsWithCurrentUser = excludeUserIds != null
        ? excludeUserIds.add(userId ?? currentUserId!)
        : [userId ?? currentUserId];
    return _powerSyncRepository.db().getAll(
      '''
      SELECT users.id, users.username, users.full_name, users.avatar_url
      FROM friendships
      JOIN users
      ON (friendships.receiver_id = users.id OR friendships.sender_id = users.id) AND users.id != ?1
      WHERE (
        (friendships.sender_id = ?1 AND friendships.receiver_id NOT IN (?2))
        OR (friendships.receiver_id = ?1 AND friendships.sender_id NOT IN (?2))
        )
        AND (
          LOWER(users.username) LIKE LOWER('%$query%')
          OR LOWER(users.full_name) LIKE LOWER('%$query%')
        )
      ''',
      [
        userId ?? currentUserId,
        [userId ?? currentUserId, excludeUserIdsWithCurrentUser].join(','),
      ],
    ).then((event) => event.safeMap(User.fromJson).toList(growable: false));
  }

  @override
  Stream<List<Challenge>> getChallenges({required String userId}) {
    return _powerSyncRepository.db().watch(
      '''
      SELECT challenges.*, users.id as creator_id, users.username as creator_username, users.full_name as creator_full_name, users.avatar_url as creator_avatar_url
      FROM participants
      JOIN challenges
      ON participants.challenge_id = challenges.id
      JOIN users
      ON challenges.creator_id = users.id
      WHERE participants.user_id = ?1
      ORDER BY challenges.created_at DESC
      ''',
      parameters: [userId],
    ).map(
      (event) => event
          .safeMap((row) => Challenge.fromJson(Map<String, dynamic>.from(row)))
          .toList(growable: false),
    );
  }

  @override
  Future<Challenge> getChallengeDetails({required String challengeId}) async {
    final challenge = await _powerSyncRepository.db().get(
      '''
      SELECT 
        challenges.*, 
        users.id as creator_id, 
        users.username as creator_username, 
        users.full_name as creator_full_name, 
        users.avatar_url as creator_avatar_url
      FROM challenges
      JOIN users
      ON challenges.creator_id = users.id
      WHERE challenges.id = ?1
      ''',
      [challengeId],
    ).then((event) => Challenge.fromJson(Map<String, dynamic>.from(event)));
    final choices = await _powerSyncRepository.db().getAll(
      '''
      SELECT * FROM choices WHERE challenge_id = ?1
      ''',
      [challengeId],
    ).then(
      (event) => event.safeMap(Choice.fromJson).toList(growable: false),
    );
    return challenge.copyWith(choices: choices);
  }

  @override
  Future<List<Participant>> getParticipants({
    required String challengeId,
  }) async {
    return _powerSyncRepository.db().getAll(
      '''
      SELECT 
        users.id as user_id, 
        users.username as username, 
        users.full_name as full_name, 
        users.avatar_url as avatar_url,
        participants.challenge_id as challenge_id,
        participants.status as status
      FROM participants
      JOIN users
      ON participants.user_id = users.id
      WHERE participants.challenge_id = ?1
      ''',
      [challengeId],
    ).then(
      (event) => event.safeMap(Participant.fromJson).toList(growable: false),
    );
  }

  @override
  Stream<List<Participant>> fetchChallengeParticipant({
    required String challengeId,
  }) {
    return _powerSyncRepository.db().watch(
      '''
      SELECT 
        users.id as user_id, 
        users.username as username, 
        users.full_name as full_name, 
        users.avatar_url as avatar_url,
        participants.challenge_id as challenge_id,
        participants.status as status
      FROM participants
      JOIN users
      ON participants.user_id = users.id
      WHERE participants.challenge_id = ?1
      ''',
      parameters: [challengeId],
    ).map(
      (event) => event.safeMap(Participant.fromJson).toList(growable: false),
    );
  }

  @override
  Future<List<Bet>> getBets({required String challengeId}) {
    return _powerSyncRepository.db().getAll(
      '''
      SELECT 
        bets.*,
        COALESCE(transactions.status, 'pending') as transaction_status
      FROM bets 
      JOIN choices ON bets.choice_id = choices.id
      LEFT JOIN transactions ON transactions.origin_id = bets.id
      WHERE choices.challenge_id = ?1
      ''',
      [challengeId],
    ).then(
      (event) => event.safeMap(Bet.fromJson).toList(growable: false),
    );
  }

  @override
  Stream<List<Bet>> fetchChallengeBets({required String challengeId}) {
    return _powerSyncRepository.db().watch(
      '''
      SELECT bets.* 
      FROM bets 
      JOIN choices ON bets.choice_id = choices.id
      WHERE choices.challenge_id = ?1
      ''',
      parameters: [challengeId],
    ).map(
      (event) => event.safeMap(Bet.fromJson).toList(growable: false),
    );
  }

  @override
  Future<Bet> upsertBet({required Bet bet}) async {
    await _powerSyncRepository.db().execute(
      '''
        INSERT INTO bets (id, choice_id, user_id, amount) VALUES(?1, ?2, ?3, ?4)
      ''',
      [bet.id, bet.choiceId, bet.userId, bet.amount],
    );
    return bet;
  }

  @override
  Future<Choice> updateChoice({required Choice choice}) {
    return _powerSyncRepository.db().writeTransaction((sqlContext) async {
      await sqlContext.execute(
        '''
        UPDATE choices
        SET is_correct = ?
        WHERE id = ?
        ''',
        [choice.isCorrect, choice.id],
      );
      return choice;
    });
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

  @override
  Stream<List<Notification>> notificationsOf({required String userId}) {
    return _powerSyncRepository.db().watch(
      '''
      SELECT *
      FROM notifications
      WHERE user_id = ?1
      ORDER BY created_at DESC
      ''',
      parameters: [userId],
    ).map(
      (event) => event.safeMap(Notification.fromJson).toList(growable: false),
    );
  }

  @override
  Future<void> markAsChecked(String notificationId) {
    return _powerSyncRepository.db().execute(
      '''
      UPDATE notifications
      SET status = 'checked'
      WHERE id = ?
      ''',
      [notificationId],
    );
  }

  @override
  Future<Participant> updateParticipant({required Participant participant}) {
    return _powerSyncRepository.db().writeTransaction((sqlContext) async {
      await sqlContext.execute(
        '''
        UPDATE participants
        SET status = ?
        WHERE user_id = ? AND challenge_id = ?
        ''',
        [participant.status.name, participant.id, participant.challengeId],
      );
      return participant;
    });
  }

  @override
  Future<int> getAward({required String betId, required String userId}) {
    return _powerSyncRepository.db().get(
      '''
      SELECT amount
      FROM transactions
      WHERE origin_id = ? AND receiver_id = ?
      ''',
      [betId, userId],
    ).then((event) => event['amount'] as int);
  }
}
