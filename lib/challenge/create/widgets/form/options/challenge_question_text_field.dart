import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class ChallengeQuestionTextField extends StatefulWidget {
  const ChallengeQuestionTextField({super.key});

  @override
  State<ChallengeQuestionTextField> createState() =>
      _ChallengeQuestionTextFieldState();
}

class _ChallengeQuestionTextFieldState
    extends State<ChallengeQuestionTextField> {
  final _debouncer = Debouncer();

  @override
  Widget build(BuildContext context) {
    final challengeQuestion = context.select(
      (CreateChallengeCubit cubit) => cubit.state.challengeQuestion,
    );
    return AppTextField(
      contentPadding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.xlg,
      ),
      hintText: context.l10n.challengeCreationQuestionFormFieldHint,
      filled: true,
      filledColor: AppColors.white,
      hintStyle: const TextStyle(
        color: AppColors.grey,
      ),
      initialValue: challengeQuestion.value,
      onChanged: (newQuestion) => _debouncer.run(
        () =>
            context.read<CreateChallengeCubit>().onQuestionChanged(newQuestion),
      ),
    );
  }
}
