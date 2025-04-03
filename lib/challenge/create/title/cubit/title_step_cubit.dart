import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_fields/form_fields.dart';

part 'title_step_state.dart';

class TitleStepCubit extends Cubit<TitleStepState> {
  TitleStepCubit() : super(const TitleStepState.initial());

  void _updateTitle(ChallengeTitle newChallengeTitle) {
    final previousState = state;

    final isValid = FormzValid([
      newChallengeTitle,
    ]).isFormValid;

    emit(
      previousState.copyWith(
        challengeTitle: newChallengeTitle,
        status: isValid ? TitleStepStatus.success : TitleStepStatus.error,
        errorMessage: isValid ? null : newChallengeTitle.errorMessage,
      ),
    );
  }

  void onTitleChanged(String newValue) {
    final shouldValidate = state.challengeTitle.invalid;
    final newChallengeTitle = shouldValidate
        ? ChallengeTitle.dirty(newValue)
        : ChallengeTitle.pure(newValue);

    _updateTitle(newChallengeTitle);
  }

  void onTitleUnfocused() {
    final newTitleState = ChallengeTitle.dirty(
      state.challengeTitle.value,
    );

    _updateTitle(newTitleState);
  }

  bool validateStep() {
    final isValid = FormzValid([
      state.challengeTitle,
    ]).isFormValid;

    emit(
      state.copyWith(
        status: isValid ? TitleStepStatus.success : TitleStepStatus.error,
        errorMessage: isValid ? null : state.challengeTitle.errorMessage,
      ),
    );

    return isValid;
  }
}
