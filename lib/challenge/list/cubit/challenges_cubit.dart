import 'package:bloc/bloc.dart';
import 'package:challenge_repository/challenge_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/shared.dart';

part 'challenges_state.dart';

class ChallengesCubit extends Cubit<ChallengesState> {
  ChallengesCubit({
    required ChallengeRepository challengeRepository,
    required String userId,
  })  : _challengeRepository = challengeRepository,
        _userId = userId,
        super(const ChallengesState.initial());

  final ChallengeRepository _challengeRepository;
  final String _userId;

  Stream<List<Challenge>> fetchChallenges() {
    return _challengeRepository.getChallenges(userId: _userId);
  }
}
