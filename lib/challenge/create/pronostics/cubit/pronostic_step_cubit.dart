import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_fields/form_fields.dart';
import 'package:shared/shared.dart';

part 'pronostic_step_state.dart';

class PronosticStepCubit extends Cubit<PronosticStepState> {
  PronosticStepCubit({
    String? question,
    List<String>? choices,
  }) : super(
          PronosticStepState.initial(
            question: question,
            choices: choices,
          ),
        );

  void _updateQuestion(ChallengeQuestion newChallengeQuestion) {
    final previousState = state;

    emit(
      previousState.copyWith(
        challengeQuestion: newChallengeQuestion,
      ),
    );
  }

  void onQuestionChanged(String newValue) {
    final shouldValidate = state.challengeQuestion.isNotValid;
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
        newChoiceInput: '', // Clear the input field after adding a choice
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

  @override
  Future<void> close() {
    logD('PronosticStepCubit closed');
    return super.close();
  }

  void onChoicesInputChanged(String value) {
    final previousState = state;

    emit(
      previousState.copyWith(
        newChoiceInput: value,
      ),
    );
  }
}
