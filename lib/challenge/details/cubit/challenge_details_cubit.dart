import 'package:bloc/bloc.dart';
import 'package:challenge_repository/challenge_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/shared.dart';
import 'package:user_repository/user_repository.dart';

part 'challenge_details_state.dart';

class ChallengeDetailsCubit extends Cubit<ChallengeDetailsState> {
  ChallengeDetailsCubit({
    required String userId,
    required String challengeId,
    required ChallengeRepository challengeRepository,
  })  : _userId = userId,
        _challengeId = challengeId,
        _challengeRepository = challengeRepository,
        super(const ChallengeDetailsState.initial());

  final String _userId;
  final String _challengeId;
  final ChallengeRepository _challengeRepository;

  Participant get userParticipation =>
      state.status == ChallengeDetailsStatus.loading
          ? Participant.anonymousParticipant
          : state.challenge!.participants.firstWhere(
              (participant) => participant.id == _userId,
              orElse: () => Participant(
                user: User.anonymous,
                status: ParticipantStatus.declined,
              ),
            );

  /// Fetches challenge details from repository and emits new state.
  Future<void> fetchChallengeDetails() async {
    final challenge = await _challengeRepository.getChallengeDetails(
      challengeId: _challengeId,
    );
    emit(
      state.copyWith(
        challenge: challenge,
        status: ChallengeDetailsStatus.loaded,
      ),
    );
  }
}
