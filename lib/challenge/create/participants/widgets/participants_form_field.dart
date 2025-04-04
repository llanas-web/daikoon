import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:daikoon_blocks_ui/daikoon_blocks_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:user_repository/user_repository.dart';

class ParticipantsFormField extends StatefulWidget {
  const ParticipantsFormField({super.key});

  @override
  State<ParticipantsFormField> createState() => _ParticipantsFormFieldState();
}

class _ParticipantsFormFieldState extends State<ParticipantsFormField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.challengeCreationParticipantsFormFieldLabel,
                style: UITextStyle.subtitle,
              ),
              DaikoonFormSelector<User>(
                hintText:
                    context.l10n.challengeCreationParticipantsFormFieldHint,
                onChange:
                    context.read<ParticipantsStepCubit>().searchNewParticipants,
                onSelect:
                    context.read<ParticipantsStepCubit>().onParticipantAdded,
                getItemLabel: (user) => user.displayUsername,
              ),
            ].spacerBetween(height: AppSpacing.md),
          ),
        ),
      ].spacerBetween(height: AppSpacing.md),
    );
  }
}
