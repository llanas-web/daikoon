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

  @override
  Stream<List<Challenge>> getChallenges({required String userId}) {
    return _databaseClient.getChallenges(userId: userId);
  }

  @override
  Future<Challenge> getChallengeDetails({required String challengeId}) {
    return _databaseClient.getChallengeDetails(challengeId: challengeId);
  }

  @override
  Stream<List<Participant>> fetchChallengeParticipant({
    required String challengeId,
  }) {
    return _databaseClient.fetchChallengeParticipant(challengeId: challengeId);
  }

  @override
  Stream<List<Bet>> fetchChallengeBets({required String challengeId}) {
    return _databaseClient.fetchChallengeBets(challengeId: challengeId);
  }

  @override
  Future<Bet> createBet({required Bet bet}) {
    return _databaseClient.createBet(bet: bet);
  }

  @override
  Future<Bet> updateBet({required Bet bet}) {
    return _databaseClient.updateBet(bet: bet);
  }

  @override
  Future<Participant> updateParticipant({required Participant participant}) {
    return _databaseClient.updateParticipant(participant: participant);
  }
}
