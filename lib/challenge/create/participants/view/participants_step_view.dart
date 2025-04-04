import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class ParticipantsStepView extends StatelessWidget {
  const ParticipantsStepView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => context.read<ParticipantsStepCubit>(),
      child: Column(
        children: [
          Text(
            context.l10n.challengeCreationParticipantsFormLabel,
            style: UITextStyle.title,
          ),
          const ParticipantsFormField(),
          const ParticipantsList(),
        ].spacerBetween(height: AppSpacing.xxlg),
      ),
    );
  }
}
