import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:daikoon_blocks_ui/daikoon_blocks_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class ChallengeInvitationPending extends StatelessWidget {
  const ChallengeInvitationPending({super.key});

  @override
  Widget build(BuildContext context) {
    final challenge = context.select(
      (ChallengeDetailsCubit cubit) => cubit.state.challenge,
    )!;
    return Column(
      children: [
        Text(
          '@${challenge.creator?.displayUsername}',
          style: UITextStyle.titleSmallBold.copyWith(
            fontWeight: AppFontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          width: 300,
          child: Text(
            context.l10n.challengeDetailsInvitationTitle(challenge.title!),
            style: UITextStyle.title,
            textAlign: TextAlign.center,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.challengeDetailsQuestionLabel,
              style: UITextStyle.subtitleBold,
            ),
            ChallengeQuestionTextField(
              initialValue: challenge.question!,
              readOnly: true,
            ),
          ].spacerBetween(height: AppSpacing.md),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'daikoins',
              style: UITextStyle.subtitleBold,
            ),
            const Icon(
              Icons.check,
              color: AppColors.secondary,
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.challengeDetailsLimitDateLabel,
              style: UITextStyle.subtitleBold,
            ),
            Row(
              children: [
                Expanded(
                  child: DaikoonFormDateSelector(
                    value: challenge.limitDate,
                    readOnly: true,
                  ),
                ),
                Expanded(
                  child: DaikoonFormTimeSelector(
                    value: challenge.limitDate,
                    readOnly: true,
                  ),
                ),
              ].spacerBetween(width: AppSpacing.md),
            ),
          ].spacerBetween(height: AppSpacing.md),
        ),
        Row(
          children: [
            Expanded(
              child: AppButton(
                text: context
                    .l10n.challengeDetailsPendingAcceptTimeLeftButtonLabel,
                // onPressed: () => context.showAdaptiveDialog<void>(
                //   builder: (context) => const Center(
                //     child: Text('test modal'),
                //   ),
                // ),
                color: AppColors.primary,
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(AppColors.primary),
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(
                      vertical: AppSpacing.lg,
                      horizontal: AppSpacing.xxlg,
                    ),
                  ),
                ),
                icon: const Icon(Icons.hourglass_bottom),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.challengeDetailsStartDateLabel,
              style: UITextStyle.subtitleBold,
            ),
            Row(
              children: [
                Expanded(
                  child: DaikoonFormDateSelector(
                    value: challenge.starting,
                    readOnly: true,
                  ),
                ),
                Expanded(
                  child: DaikoonFormTimeSelector(
                    value: challenge.starting,
                    readOnly: true,
                  ),
                ),
              ].spacerBetween(width: AppSpacing.md),
            ),
          ].spacerBetween(height: AppSpacing.md),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.challengeDetailsEndDateLabel,
              style: UITextStyle.subtitleBold,
            ),
            Row(
              children: [
                Expanded(
                  child: DaikoonFormDateSelector(
                    value: challenge.ending,
                    readOnly: true,
                  ),
                ),
                Expanded(
                  child: DaikoonFormTimeSelector(
                    value: challenge.ending,
                    readOnly: true,
                  ),
                ),
              ].spacerBetween(width: AppSpacing.md),
            ),
          ].spacerBetween(height: AppSpacing.md),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.challengeDetailsPendingListParticipantLabel,
              style: UITextStyle.subtitleBold,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: challenge.participants.length,
              itemBuilder: (context, index) {
                return Text(
                  '@${challenge.participants[index].displayUsername}',
                  style: UITextStyle.subtitle,
                );
              },
            ),
          ].spacerBetween(height: AppSpacing.md),
        ),
        Row(
          children: [
            Expanded(
              child: AppButton(
                text:
                    context.l10n.challengeDetailsPendingParticipateButtonLabel,
                onPressed: () =>
                    context.read<ChallengeDetailsCubit>().acceptInvitation(),
                color: AppColors.secondary,
                textStyle: UITextStyle.button.copyWith(
                  color: context.reversedAdaptiveColor,
                ),
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(AppColors.secondary),
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(
                      vertical: AppSpacing.lg,
                      horizontal: AppSpacing.xxlg,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: AppButton(
                text: context.l10n.challengeDetailsPendingRefuseButtonLabel,
                onPressed: () =>
                    context.read<ChallengeDetailsCubit>().declineInvitation(),
                color: AppColors.primary,
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(AppColors.primary),
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(
                      vertical: AppSpacing.lg,
                      horizontal: AppSpacing.xxlg,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ].spacerBetween(height: AppSpacing.xlg),
    );
  }
}
