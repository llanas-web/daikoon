import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_fields/form_fields.dart';

part 'pronostic_step_state.dart';

class PronosticStepCubit extends Cubit<PronosticStepState> {
  PronosticStepCubit() : super(const PronosticStepState.initial());

  void _updateQuestion(ChallengeQuestion newChallengeQuestion) {
    final previousState = state;

    final isValid = FormzValid([
      newChallengeQuestion,
    ]).isFormValid;

    emit(
      previousState.copyWith(
        challengeQuestion: newChallengeQuestion,
        status:
            isValid ? PronosticStepStatus.success : PronosticStepStatus.error,
        errorMessage: isValid ? null : newChallengeQuestion.errorMessage,
      ),
    );
  }

  void onQuestionChanged(String newValue) {
    final shouldValidate = state.challengeQuestion.invalid;
    final newChallengeQuestion = shouldValidate
        ? ChallengeQuestion.dirty(newValue)
        : ChallengeQuestion.pure(newValue);

    _updateQuestion(newChallengeQuestion);
  }

  void onQuestionUnfocused() {
    final newQuestionState = ChallengeQuestion.dirty(
      state.challengeQuestion.value,
    );

    _updateQuestion(newQuestionState);
  }

  void onChoicesAdded(String newChoice) {
    final previousState = state;
    final newChoices = List<String>.from(previousState.choices)..add(newChoice);

    emit(
      previousState.copyWith(
        choices: newChoices,
      ),
    );
  }

  void onChoicesRemoved(String choiceToRemove) {
    final previousState = state;
    final newChoices = List<String>.from(previousState.choices)
      ..remove(choiceToRemove);

    emit(
      previousState.copyWith(
        choices: newChoices,
      ),
    );
  }

  bool validateStep() {
    final isQuestionValid = FormzValid([
      state.challengeQuestion,
    ]).isFormValid;
    if (!isQuestionValid) {
      emit(
        state.copyWith(
          status: PronosticStepStatus.error,
          errorMessage: state.challengeQuestion.errorMessage,
        ),
      );
      return false;
    }

    // Check if choices are valid
    final isChoicesValid = state.choices.isNotEmpty &&
        state.choices.length >= 2 &&
        state.choices.every((choice) => choice.isNotEmpty);
    emit(
      state.copyWith(
        choices: state.choices,
        challengeQuestion: state.challengeQuestion,
        status: isChoicesValid
            ? PronosticStepStatus.success
            : PronosticStepStatus.error,
        errorMessage:
            isChoicesValid ? null : state.challengeQuestion.errorMessage,
      ),
    );

    return isChoicesValid;
  }
}
