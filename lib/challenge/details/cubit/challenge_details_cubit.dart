import 'package:bloc/bloc.dart';
import 'package:challenge_repository/challenge_repository.dart';
import 'package:collection/collection.dart';
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
        super(ChallengeDetailsState.initial(userId));

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

  void selectChoice(Choice choice) {
    emit(
      state.copyWith(
        userBet: state.userBet.copyWith(
          choiceId: choice.id,
        ),
      ),
    );
  }

  void setBetAmount(int? amount) {
    emit(
      state.copyWith(
        userBet: state.userBet.copyWith(
          amount: amount ?? 0,
        ),
      ),
    );
  }

  Future<void> createBet() async {
    if (state.userBet.choiceId != '') {
      await _challengeRepository.createBet(
        bet: state.userBet,
      );
    }
  }

  Future<void> fetchChallengeBets() async {
    _challengeRepository
        .fetchChallengeBets(
          challengeId: _challengeId,
        )
        .listen(
          (bets) => state.copyWith(
            bets: bets,
            userBet: bets.firstWhereOrNull(
              (bet) => bet.userId == _userId,
            ),
          ),
        );
  }

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

  Future<void> declineInvitation() {
    return _challengeRepository.updateParticipant(
      participant: userParticipation.copyWith(
        status: ParticipantStatus.declined,
      ),
    );
  }

  Future<void> acceptInvitation() {
    return _challengeRepository.updateParticipant(
      participant: userParticipation.copyWith(
        status: ParticipantStatus.accepted,
      ),
    );
  }
}
