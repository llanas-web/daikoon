import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class ChallengeTitleForm extends StatelessWidget {
  const ChallengeTitleForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          context.l10n.challengeCreationTitleFormLabel,
          style: UITextStyle.title,
        ),
        const Row(
          children: [
            Expanded(
              child: ChallengeTitleFormField(),
            ),
          ],
        ),
      ].spacerBetween(height: AppSpacing.xxlg),
    );
  }
}
