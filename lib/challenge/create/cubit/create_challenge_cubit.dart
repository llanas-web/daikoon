import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_fields/form_fields.dart';
import 'package:user_repository/user_repository.dart';

part 'create_challenge_state.dart';

class CreateChallengeCubit extends Cubit<CreateChallengeState> {
  CreateChallengeCubit() : super(const CreateChallengeState.initial());

  /// Emits initial state of challenge creation screen.
  void resetState() => emit(const CreateChallengeState.initial());

  /// Title value was changed, triggering new changes in state.
  void onTitleChanged(String newValue) {
    final previousState = state;
    final newTitle = newValue;
    final shouldValidate = previousState.challengeTitle.invalid;
    final newChallengeTitle = shouldValidate
        ? ChallengeTitle.dirty(
            newTitle,
          )
        : ChallengeTitle.pure(
            newTitle,
          );

    final newState = previousState.copyWith(
      challengeTitle: newChallengeTitle,
    );
    emit(newState);
  }

  void onQuestionChanged(String newValue) {
    final previousState = state;
    final newQuestion = newValue;
    final shouldValidate = previousState.challengeQuestion.invalid;
    final newChallengeQuestion = shouldValidate
        ? ChallengeQuestion.dirty(
            newQuestion,
          )
        : ChallengeQuestion.pure(
            newQuestion,
          );

    final newState = previousState.copyWith(
      challengeQuestion: newChallengeQuestion,
    );
    emit(newState);
  }

  void onOptionAdded(String newOption) {
    final previousState = state;
    final newOptions = List<String>.from(previousState.options)..add(newOption);
    final newState = previousState.copyWith(
      options: newOptions,
    );
    emit(newState);
  }

  void onOptionRemoved(int index) {
    final previousState = state;
    final newOptions = List<String>.from(previousState.options)
      ..removeAt(index);
    final newState = previousState.copyWith(
      options: newOptions,
    );
    emit(newState);
  }

  void onSetHasBet({bool? hasBet}) {
    final previousState = state;
    final newState = previousState.copyWith(
      hasBet: hasBet ?? !previousState.hasBet,
    );
    emit(newState);
  }

  void onMinAmountChanged(int newMinAmount) {
    final previousState = state;
    final newState = previousState.copyWith(
      minAmount: newMinAmount,
      noBetAmount: false,
    );
    emit(newState);
  }

  void onMaxAmountChanged(int newMaxAmount) {
    final previousState = state;
    final newState = previousState.copyWith(
      maxAmount: newMaxAmount,
      noBetAmount: false,
    );
    emit(newState);
  }

  void onNoBetAmount({bool? isSelected}) {
    final previousState = state;
    final newState = previousState.copyWith(
      noBetAmount: isSelected ?? !previousState.noBetAmount,
    );
    emit(newState);
  }

  void onParticipantAdded(User user) {
    final previousState = state;
    final newParticipants = List<User>.from(previousState.participants)
      ..add(user);
    final newState = previousState.copyWith(
      participants: newParticipants,
    );
    emit(newState);
  }

  void onParticipantRemoved(User user) {
    final previousState = state;
    final newParticipants = List<User>.from(previousState.participants)
      ..remove(user);
    final newState = previousState.copyWith(
      participants: newParticipants,
    );
    emit(newState);
  }
}
