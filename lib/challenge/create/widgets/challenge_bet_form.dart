import 'package:app_ui/app_ui.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class ChallengeBetForm extends StatefulWidget {
  const ChallengeBetForm({super.key});

  @override
  State<ChallengeBetForm> createState() => _ChallengeBetFormState();
}

class _ChallengeBetFormState extends State<ChallengeBetForm> {
  var hasBet = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          context.l10n.challengeCreationBetFormLabel,
          style: context.headlineMedium,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadioListTile<bool>(
              title: Text(context.l10n.challengeCreationBetFormFieldTrue),
              value: true,
              groupValue: hasBet,
              onChanged: (value) {
                setState(() {
                  hasBet = value!;
                });
              },
            ),
            RadioListTile<bool>(
              title: Text(context.l10n.challengeCreationBetFormFieldFalse),
              value: false,
              groupValue: hasBet,
              onChanged: (value) {
                setState(() {
                  hasBet = value!;
                });
              },
            ),
          ].spacerBetween(height: AppSpacing.md),
        ),
      ],
    );
  }
}
