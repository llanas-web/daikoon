import 'package:bloc/bloc.dart';
import 'package:challenge_repository/challenge_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/shared.dart';
import 'package:user_repository/user_repository.dart';

part 'create_challenge_state.dart';

class CreateChallengeCubit extends Cubit<CreateChallengeState> {
  CreateChallengeCubit({
    required ChallengeRepository challengeRepository,
  })  : _challengeRepository = challengeRepository,
        super(const CreateChallengeState.initial());

  final ChallengeRepository _challengeRepository;

  /// Emits initial state of challenge creation screen.
  void resetState() => emit(const CreateChallengeState.initial());

  void updateTitle(String newTitle) {
    emit(state.copyWith(title: newTitle));
  }

  void updatePronostic(String question, List<String> choices) {
    emit(
      state.copyWith(
        question: question,
        choices: choices,
      ),
    );
  }

  void updateBetAmount({
    required int minAmount,
    required int maxAmount,
    required bool noBetAmount,
  }) {
    emit(
      state.copyWith(
        minAmount: minAmount,
        maxAmount: maxAmount,
        noBetAmount: false,
      ),
    );
  }

  void onSetHasBet({bool? hasBet}) {
    final previousState = state;
    final newState = previousState.copyWith(
      hasBet: hasBet ?? !previousState.hasBet,
    );
    emit(newState);
  }

  void onParticipantAdded(User user) {
    final previousState = state;
    final newParticipants = List<Participant>.from(previousState.participants)
      ..add(Participant(user: user));
    final newState = previousState.copyWith(
      participants: newParticipants,
    );
    emit(newState);
  }

  void onParticipantRemoved(User user) {
    final previousState = state;
    final newParticipants = List<Participant>.from(previousState.participants)
      ..removeWhere((participant) => participant.id == user.id);
    final newState = previousState.copyWith(
      participants: newParticipants,
    );
    emit(newState);
  }

  Future<void> submit({
    required User creator,
  }) async {
    emit(state.copyWith(status: CreateChallengeStatus.loading));
    final newChallenge = Challenge(
      title: state.title,
      question: state.question,
      choices: state.choices.map((choice) => Choice(value: choice)).toList(),
      hasBet: state.hasBet,
      minBet: state.minAmount,
      maxBet: state.maxAmount,
      participants: state.participants,
      starting: state.startDate,
      limitDate: state.limitDate,
      ending: state.endDate,
    );
    try {
      await _challengeRepository.createChallenge(
        challenge: newChallenge,
        creator: creator,
        choices: newChallenge.choices,
        participants: newChallenge.participants,
      );
      emit(
        state.copyWith(
          status: CreateChallengeStatus.success,
          challengeId: newChallenge.id,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateChallengeStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
