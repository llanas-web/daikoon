import 'package:app_ui/app_ui.dart';
import 'package:challenge_repository/challenge_repository.dart';
import 'package:collection/collection.dart';
import 'package:daikoon/app/app.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class ChallengeEndedDetails extends StatelessWidget {
  const ChallengeEndedDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AppBloc>().state.user.id;
    final challengeCubit = context.read<ChallengeDetailsCubit>();
    final challenge = challengeCubit.state.challenge!;
    final bets = challengeCubit.state.bets;
    final correctChoice = challenge.choices.firstWhereOrNull(
      (choice) => choice.isCorrect,
    );
    final winners = bets
        .where(
          (bet) => bet.choiceId == correctChoice?.id,
        )
        .map(
          (bet) => challenge.participants.firstWhereOrNull(
            (participant) => participant.id == bet.userId,
          ),
        )
        .toList();

    final hasWon = winners.any(
      (winner) => winner?.id == context.read<AppBloc>().state.user.id,
    );

    Future<int> getAwardAmount() async {
      if (challengeCubit.userBet == null) return 0;
      return context.read<ChallengeRepository>().getAward(
            betId: challengeCubit.userBet!.id,
            userId: userId,
          );
    }

    return Column(
      children: [
        Text(
          challenge.title!,
          style: UITextStyle.subtitle.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          width: 300,
          child: Text(
            hasWon
                ? context.l10n.challengeDetailsEndedWonTitle
                : context.l10n.challengeDetailsEndedLoseTitle,
            style: UITextStyle.title,
            textAlign: TextAlign.center,
          ),
        ),
        Text(
          hasWon ? '🥳' : '😭',
          style: context.headlineLarge?.copyWith(
            fontSize: 64,
          ),
          textAlign: TextAlign.center,
        ),
        Column(
          children: [
            Text(
              context.l10n.challengeDetailsEndedWinnersLabel,
              style: UITextStyle.titleSmallBold,
            ),
            Text(
              winners.isEmpty
                  ? context.l10n.challengeDetailsEndedNoWinnersLabel
                  : winners
                      .map(
                        (winner) => '@${winner?.displayUsername}',
                      )
                      .join(', '),
              style: UITextStyle.title2,
              textAlign: TextAlign.center,
            ),
          ].spacerBetween(height: AppSpacing.md),
        ),
        if (challenge.hasBet)
          Column(
            children: [
              Text(
                context.l10n.challengeDetailsEndedDaikoinsWinLabel,
                style: UITextStyle.titleSmallBold,
              ),
              FutureBuilder<int>(
                future: getAwardAmount(),
                builder: (context, snapshot) => Text(
                  snapshot.connectionState == ConnectionState.waiting
                      ? '...'
                      : hasWon
                          ? '${snapshot.data} Daikoins'
                          : '0 Daikoins',
                  style: UITextStyle.title2,
                ),
              ),
            ].spacerBetween(height: AppSpacing.md),
          ),
      ].spacerBetween(height: AppSpacing.xlg),
    );
  }
}
