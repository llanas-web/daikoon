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

  Future<void> upsertBet({
    required String choiceId,
    required int amount,
  }) async {
    if (userBet != null) {
      await _challengeRepository.upsertBet(
        bet: userBet!.copyWith(
          amount: amount,
          choiceId: choiceId,
        ),
      );
      return;
    } else {
      final bet = Bet(
        amount: amount,
        choiceId: choiceId,
        userId: _userId,
      );
      final newBet = await _challengeRepository.upsertBet(
        bet: bet,
      );
      emit(
        state.copyWith(
          bets: [
            ...state.bets.where((b) => b.id != newBet.id),
            newBet,
          ],
        ),
      );
      if (_betsSubscription == null) {
        if (!isClosed) {
          fetchBetStream();
        }
      }
    }
  }

  void fetchBetStream() {
    _betsSubscription = _challengeRepository
        .fetchChallengeBets(
          challengeId: _challengeId,
        )
        .listen(
          (bets) => emit(
            state.copyWith(bets: bets),
          ),
        );
  }

  void fetchParticipantsStream() {
    _participantsSubscription = _challengeRepository
        .fetchChallengeParticipant(
          challengeId: _challengeId,
        )
        .listen(
          (participants) => emit(
            state.copyWith(
              challenge: state.challenge!.copyWith(
                participants: participants,
              ),
            ),
          ),
        );
  }

  Future<void> fetchChallengeDetails() async {
    final challenge = await _challengeRepository.getChallengeDetails(
      challengeId: _challengeId,
    );

    if (_participantsSubscription == null) {
      fetchParticipantsStream();
    }

    if (_betsSubscription == null) {
      fetchBetStream();
    }

    emit(
      state.copyWith(
        challenge: challenge,
        status: ChallengeDetailsStatus.loaded,
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
      emit(
        state.copyWith(
          challenge: state.challenge!.copyWith(
            choices: state.challenge!.choices
                .map(
                  (c) => c.id == choiceId ? newChoice : c,
                )
                .toList(),
          ),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _betsSubscription?.cancel();
    _participantsSubscription?.cancel();
    return super.close();
  }
}
