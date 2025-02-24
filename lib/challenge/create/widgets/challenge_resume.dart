import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChallengeResume extends StatelessWidget {
  const ChallengeResume({super.key});

  @override
  Widget build(BuildContext context) {
    final challengeState = context.read<CreateChallengeCubit>().state;
    return Column(
      children: [
        Text(
          context.l10n.challengeCreationResumeLabel,
          style: context.headlineMedium,
        ),
        Text(context.l10n.challengeCreationTitleFormLabel),
        Text(context.l10n.challengeCreationOptionsFormLabel),
        Text(context.l10n.challengeCreationBetFormLabel),
        if (challengeState.hasBet)
          Text(context.l10n.challengeCreationBetAmountFormLabel),
        Text(context.l10n.challengeCreationParticipantsFormLabel),
        Text(context.l10n.challengeCreationDatesFormLabel),
      ],
    );
  }
}
