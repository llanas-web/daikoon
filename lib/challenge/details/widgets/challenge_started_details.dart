import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:daikoon_blocks_ui/daikoon_blocks_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class ChallengeStartedDetails extends StatelessWidget {
  const ChallengeStartedDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final userParticipation = context.select(
      (ChallengeDetailsCubit cubit) => cubit.userParticipation,
    );

    switch (userParticipation.status) {
      case ParticipantStatus.pending:
        return const ChallengeInvitationPending();
      case ParticipantStatus.accepted:
        return const ChallengeInvitationAccepted();
      case ParticipantStatus.declined:
        return const ChallengeInvitationDeclined();
    }
  }
}

class ChallengeInvitationAccepted extends StatelessWidget {
  const ChallengeInvitationAccepted({super.key});

  @override
  Widget build(BuildContext context) {
    final challenge = context.select(
      (ChallengeDetailsCubit cubit) => cubit.state.challenge,
    )!;
    final userBet = context.select(
      (ChallengeDetailsCubit cubit) => cubit.state.userBet,
    );

    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            context.l10n.challengeDetailsAcceptedCreatorTitle(
              challenge.creator!.displayUsername,
            ),
            style: context.headlineSmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            width: 300,
            child: Text(
              context.l10n.challengeDetailsInvitationTitle(challenge.title!),
              style: context.headlineLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.challengeDetailsQuestionLabel,
                style: const TextStyle(
                  fontWeight: AppFontWeight.extraBold,
                ),
              ),
              ChallengeQuestionTextField(
                initialValue: challenge.question!,
                readOnly: true,
              ),
            ].spacerBetween(height: AppSpacing.md),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.challengeDetailsAcceptedChoiceLabel,
                style: const TextStyle(
                  fontWeight: AppFontWeight.extraBold,
                ),
              ),
              if (challenge.choices.isNotEmpty)
                Column(
                  children: challenge.choices
                      .map((choice) {
                        return DaikoonFormRadioItem(
                          title: choice.value,
                          isSelected: choice.id == userBet.choiceId,
                          onTap: () => context
                              .read<ChallengeDetailsCubit>()
                              .selectChoice(choice),
                        );
                      })
                      .toList()
                      .spacerBetween(height: AppSpacing.md),
                ),
            ],
          ),
        ].spacerBetween(height: AppSpacing.lg),
      ),
    );
  }
}

class ChallengeInvitationPending extends StatelessWidget {
  const ChallengeInvitationPending({super.key});

  @override
  Widget build(BuildContext context) {
    final challenge = context.select(
      (ChallengeDetailsCubit cubit) => cubit.state.challenge,
    )!;
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            '@${challenge.creator!.displayUsername}',
            style: context.headlineSmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            width: 300,
            child: Text(
              context.l10n.challengeDetailsInvitationTitle(challenge.title!),
              style: context.headlineLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.challengeDetailsQuestionLabel,
                style: const TextStyle(
                  fontWeight: AppFontWeight.extraBold,
                ),
              ),
              ChallengeQuestionTextField(
                initialValue: challenge.question!,
                readOnly: true,
              ),
            ].spacerBetween(height: AppSpacing.md),
          ),
        ].spacerBetween(height: AppSpacing.lg),
      ),
    );
  }
}

class ChallengeInvitationDeclined extends StatelessWidget {
  const ChallengeInvitationDeclined({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
