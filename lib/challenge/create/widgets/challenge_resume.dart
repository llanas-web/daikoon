import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:daikoon_blocks_ui/daikoon_blocks_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class ChallengeResume extends StatelessWidget {
  const ChallengeResume({super.key});

  @override
  Widget build(BuildContext context) {
    final challengeState = context.read<CreateChallengeCubit>().state;

    return Column(
      children: [
        Text(
          context.l10n.challengeCreationResumeLabel,
          style: UITextStyle.title,
          textAlign: TextAlign.center,
        ),
        _ResumeItem(
          title: context.l10n.challengeCreationTitleFormLabel,
          index: 0,
          children: [
            Text(
              challengeState.title!,
              style: UITextStyle.subtitle,
            ),
          ],
        ),
        _ResumeItem(
          title: context.l10n.challengeCreationOptionsFormLabel,
          index: 1,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.challengeDetailsQuestionLabel,
                  style: UITextStyle.subtitle,
                ),
                ChallengeQuestionTextField(
                  initialValue: challengeState.challengeQuestion.value,
                  readOnly: true,
                ),
              ].spacerBetween(height: AppSpacing.md),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.challengeDetailsAcceptedChoiceLabel,
                  style: UITextStyle.subtitle,
                ),
                if (challengeState.choices.isNotEmpty)
                  Column(
                    children: challengeState.choices
                        .map((choice) {
                          return DaikoonFormRadioItem(
                            title: choice,
                            readOnly: true,
                          );
                        })
                        .toList()
                        .spacerBetween(height: AppSpacing.md),
                  ),
              ].spacerBetween(height: AppSpacing.md),
            ),
          ].spacerBetween(height: AppSpacing.lg),
        ),
        _ResumeItem(
          title: context.l10n.challengeCreationParticipantsFormLabel,
          index: 2,
          children: [
            ...challengeState.participants.map(
              (participantUsername) => Text(
                '@${participantUsername.displayUsername}',
                style: UITextStyle.subtitle,
              ),
            ),
          ],
        ),
        _ResumeItem(
          title: context.l10n.challengeCreationDatesFormLabel,
          index: 3,
          children: [
            ChallengeDates(
              date: challengeState.startDate!,
              title: context.l10n.challengeDetailsStartDateLabel,
              readOnly: true,
            ),
            ChallengeDates(
              date: challengeState.limitDate!,
              title: context.l10n.challengeDetailsLimitDateLabel,
              readOnly: true,
            ),
            ChallengeDates(
              date: challengeState.endDate!,
              title: context.l10n.challengeDetailsEndDateLabel,
              readOnly: true,
            ),
          ].spacerBetween(height: AppSpacing.lg),
        ),
      ].spacerBetween(height: AppSpacing.xxlg),
    );
  }
}

class _ResumeItem extends StatelessWidget {
  const _ResumeItem({
    required this.title,
    required this.index,
    required this.children,
  });

  final String title;
  final int index;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: UITextStyle.subtitleBold),
            Tappable(
              onTap: () => context.read<FormStepperCubit>().goTo(index),
              child: const Icon(
                Icons.edit,
                color: AppColors.lightBlue,
              ),
            ),
          ],
        ),
        const AppDivider(
          color: AppColors.lightGrey,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ].spacerBetween(height: AppSpacing.lg),
    );
  }
}
