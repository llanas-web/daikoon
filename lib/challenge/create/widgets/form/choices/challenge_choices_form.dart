import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class ChallengeChoicesForm extends StatelessWidget {
  const ChallengeChoicesForm({super.key});

  @override
  Widget build(BuildContext context) {
    final options = context.select(
      (CreateChallengeCubit cubit) => cubit.state.choices,
    );
    final question = context.select(
      (CreateChallengeCubit cubit) => cubit.state.challengeQuestion,
    );
    return Column(
      children: [
        Text(
          context.l10n.challengeCreationOptionsFormLabel,
          style: UITextStyle.title,
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${context.l10n.challengeCreationQuestionFormFieldLabel} :',
                    style: UITextStyle.subtitle,
                  ),
                  ChallengeQuestionTextField(
                    initialValue: question.value,
                    onQuestionChanged: (question) => context
                        .read<CreateChallengeCubit>()
                        .onQuestionChanged(question),
                  ),
                ].spacerBetween(height: AppSpacing.md),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${context.l10n.challengeCreationOptionsFormFieldLabel} :',
              style: UITextStyle.subtitle,
            ),
            if (options.isNotEmpty)
              Column(
                children: options
                    .map((option) {
                      final index = options.indexOf(option);
                      return _OptionItem(
                        option: option,
                        onRemove: () => context
                            .read<CreateChallengeCubit>()
                            .onChoicesRemoved(index),
                      );
                    })
                    .toList()
                    .spacerBetween(height: AppSpacing.md),
              ),
            const Gap.v(AppSpacing.lg),
            const Row(
              children: [
                Expanded(
                  child: ChallengeChoicesTextField(),
                ),
              ],
            ),
          ],
        ),
      ].spacerBetween(height: AppSpacing.xxlg),
    );
  }
}

class _OptionItem extends StatelessWidget {
  const _OptionItem({
    required this.option,
    required this.onRemove,
  });

  final String option;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              color: AppColors.white,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.lg,
              horizontal: AppSpacing.xlg,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  option,
                  style: UITextStyle.subtitle.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                Tappable(
                  onTap: onRemove,
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
