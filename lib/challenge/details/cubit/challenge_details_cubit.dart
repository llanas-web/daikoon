import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:challenge_repository/challenge_repository.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/shared.dart';

part 'challenge_details_state.dart';

class ChallengeDetailsCubit extends Cubit<ChallengeDetailsState> {
  ChallengeDetailsCubit({
    required String userId,
    required String challengeId,
    required ChallengeRepository challengeRepository,
  })  : _userId = userId,
        _challengeId = challengeId,
        _challengeRepository = challengeRepository,
        super(ChallengeDetailsState.initial());

  final String _userId;
  final String _challengeId;
  final ChallengeRepository _challengeRepository;

  StreamSubscription<List<Bet>>? _betsSubscription;
  StreamSubscription<List<Participant>>? _participantsSubscription;

  bool get isOwner => state.challenge?.creator?.id == _userId;

  Participant? get userParticipation {
    if (state.status == ChallengeDetailsStatus.loading) return null;

    return state.challenge!.participants.firstWhereOrNull(
      (participant) => participant.id == _userId,
    );
  }

  Bet? get userBet => state.bets.firstWhereOrNull(
        (bet) => bet.userId == _userId,
      );

  Future<void> createOrUpdateBet({
    required String choiceId,
    required int amount,
  }) async {
    if (userBet != null) {
      await _challengeRepository.updateBet(
        bet: userBet!.copyWith(
          amount: amount,
          choiceId: choiceId,
        ),
      );
      return;
    } else {
      final bet = userBet ??
          Bet(
            amount: amount,
            choiceId: choiceId,
            userId: _userId,
          );
      await _challengeRepository.createBet(
        bet: bet,
      );
    }
  }

  Future<void> fetchChallengeDetails() async {
    final challenge = await _challengeRepository.getChallengeDetails(
      challengeId: _challengeId,
    );
    final participantStream = _challengeRepository.fetchChallengeParticipant(
      challengeId: _challengeId,
    );
    final betStream = _challengeRepository.fetchChallengeBets(
      challengeId: _challengeId,
    );

    final listParticipant = await participantStream.first;
    final listBet = await betStream.first;

    emit(
      state.copyWith(
        challenge: challenge.copyWith(
          participants: listParticipant,
        ),
        bets: listBet,
        status: ChallengeDetailsStatus.loaded,
      ),
    );

    _betsSubscription = betStream.listen(
      (bets) => emit(
        state.copyWith(bets: bets),
      ),
    );
    _participantsSubscription = participantStream.listen(
      (participants) => emit(
        state.copyWith(
          challenge: state.challenge!.copyWith(
            participants: participants,
          ),
        ),
      ),
    );
  }

  Future<void> declineInvitation() {
    return _challengeRepository.updateParticipant(
      participant: userParticipation!.copyWith(
        status: ParticipantStatus.declined,
      ),
    );
  }

  Future<void> acceptInvitation() {
    return _challengeRepository.updateParticipant(
      participant: userParticipation!.copyWith(
        status: ParticipantStatus.accepted,
      ),
    );
  }

  Future<void> validateChoice(String choiceId) async {
    final choice = state.challenge!.choices.firstWhereOrNull(
      (choice) => choice.id == choiceId,
    );

    if (choice != null && !choice.isCorrect) {
      final newChoice = choice.copyWith(isCorrect: true);
      await _challengeRepository.updateChoice(choice: newChoice);
    }
  }

  @override
  Future<void> close() {
    _betsSubscription?.cancel();
    _participantsSubscription?.cancel();
    return super.close();
  }
}
