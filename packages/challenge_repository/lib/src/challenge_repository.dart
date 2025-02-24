import 'package:database_client/database_client.dart';
import 'package:shared/shared.dart';
import 'package:user_repository/user_repository.dart';

/// {@template challenge_repository}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class ChallengeRepository implements ChallengeBaseRepository {
  /// {@macro challenge_repository}
  const ChallengeRepository({
    required DatabaseClient databaseClient,
  }) : _databaseClient = databaseClient;

  final DatabaseClient _databaseClient;

  @override
  Future<void> createChallenge({
    required Challenge challenge,
    required User creator,
    List<Choice> choices = const [],
    List<Participant> participants = const [],
  }) =>
      _databaseClient.createChallenge(
        challenge: challenge,
        creator: creator,
        choices: choices,
        participants: participants,
      );
}
