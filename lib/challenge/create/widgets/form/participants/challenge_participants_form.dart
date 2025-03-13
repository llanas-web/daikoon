import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class ChallengeParticipantsForm extends StatelessWidget {
  const ChallengeParticipantsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final participants = context.select(
      (CreateChallengeCubit cubit) => cubit.state.participants,
    );

    return Column(
      children: [
        Text(
          l10n.challengeCreationParticipantsFormLabel,
          style: context.headlineMedium,
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${l10n.challengeCreationParticipantsFormFieldLabel} :',
                  ),
                  const ChallengeParticipantsFormField(),
                ],
              ),
            ),
          ].spacerBetween(height: AppSpacing.md),
        ),
        Text(
          participants.isEmpty
              ? ''
              : participants
                  .map((participant) => participant.username)
                  .join(', '),
        ),
      ].spacerBetween(height: AppSpacing.xlg),
    );
  }
}
