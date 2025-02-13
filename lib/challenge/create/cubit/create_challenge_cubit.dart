import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_fields/form_fields.dart';

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
}
