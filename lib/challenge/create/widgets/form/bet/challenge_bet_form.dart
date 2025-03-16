import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:daikoon_blocks_ui/daikoon_blocks_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class ChallengeBetForm extends StatelessWidget {
  const ChallengeBetForm({super.key});

  @override
  Widget build(BuildContext context) {
    final hasBet =
        context.select((CreateChallengeCubit cubit) => cubit.state.hasBet);
    return Column(
      children: [
        Text(
          context.l10n.challengeCreationBetFormLabel,
          style: UITextStyle.title,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DaikoonFormRadioItem(
              title: context.l10n.challengeCreationBetFormFieldTrue,
              onTap: () => context
                  .read<CreateChallengeCubit>()
                  .onSetHasBet(hasBet: true),
              isSelected: hasBet,
            ),
            DaikoonFormRadioItem(
              title: context.l10n.challengeCreationBetFormFieldFalse,
              onTap: () => context
                  .read<CreateChallengeCubit>()
                  .onSetHasBet(hasBet: false),
              isSelected: !hasBet,
            ),
          ].spacerBetween(height: AppSpacing.md),
        ),
      ].spacerBetween(height: AppSpacing.xxlg),
    );
  }
}
