import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/app.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';

class ChallengeLimitDetails extends StatelessWidget {
  const ChallengeLimitDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final challengeDetailsCubit = context.read<ChallengeDetailsCubit>();
    final challenge = challengeDetailsCubit.state.challenge!;
    final choices = challengeDetailsCubit.state.challenge!.choices;
    final bets = challengeDetailsCubit.state.bets;

    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            context.l10n.challengeDetailsStatsCreatorTitle(
              challenge.creator!.displayUsername,
            ),
            style: context.headlineSmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            width: 300,
            child: Text(
              context.l10n.challengeDetailsStatsTitle(challenge.title!),
              style: context.headlineLarge,
              textAlign: TextAlign.center,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: choices.length,
            itemBuilder: (context, index) {
              final choice = choices[index];
              final choiceBets = bets.where(
                (bet) => bet.choiceId == choice.id,
              );
              final participantUsernames = choiceBets
                  .map((bet) => bet.userId)
                  .map(
                    (userId) => challenge.participants
                        .firstWhere((participant) => participant.id == userId)
                        .displayUsername,
                  )
                  .join(', ');
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        choice.value,
                        style: const TextStyle(
                          fontWeight: AppFontWeight.extraBold,
                        ),
                      ),
                      Text(
                        '${bets.length}',
                        style: const TextStyle(
                          fontWeight: AppFontWeight.extraBold,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  LinearProgressIndicator(
                    value: choiceBets.length / bets.length,
                    minHeight: 18,
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(18),
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withValues(alpha: 0.17),
                  ),
                  if (participantUsernames.isEmpty)
                    const Text('Vote de : personne')
                  else
                    Text('Vote de : $participantUsernames'),
                ].spacerBetween(height: AppSpacing.md),
              );
            },
          ),
          if (challengeDetailsCubit.isOwner)
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: context.l10n.challengeDetailsStatsButtonLabel,
                    onPressed: () => context.pushNamed(
                      AppRoutes.challengeDetailsFinish.name,
                      pathParameters: {'challengeId': challenge.id},
                    ),
                    color: AppColors.secondary,
                    style: const ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(AppColors.secondary),
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
      ),
    );
  }
}
