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

    final participantsNames = context
        .select(
          (CreateChallengeCubit cubit) => cubit.state.participants,
        )
        .map((participant) => participant.displayUsername);

    return Column(
      children: [
        Text(
          l10n.challengeCreationParticipantsFormLabel,
          style: UITextStyle.title,
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${l10n.challengeCreationParticipantsFormFieldLabel} :',
                    style: UITextStyle.subtitle,
                  ),
                  const ChallengeParticipantsFormField(),
                ].spacerBetween(height: AppSpacing.md),
              ),
            ),
          ].spacerBetween(height: AppSpacing.md),
        ),
        if (participantsNames.isEmpty)
          const SizedBox.shrink()
        else
          Text(
            participantsNames.join(', '),
            style: UITextStyle.bodyText.copyWith(
              fontStyle: FontStyle.italic,
              color: AppColors.grey,
            ),
            textAlign: TextAlign.start,
          ),
      ].spacerBetween(height: AppSpacing.xlg),
    );
  }
}
