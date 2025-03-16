import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/create/widgets/form/dates/dates.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class ChallengeDatesForm extends StatelessWidget {
  const ChallengeDatesForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          context.l10n.challengeCreationDatesFormLabel,
          style: UITextStyle.title,
        ),
        Column(
          children: [
            const ChallengeDateStartFormField(),
            const ChallengeDateLimitFormField(),
            const ChallengeDateEndFormField(),
          ].spacerBetween(height: AppSpacing.lg),
        ),
      ].spacerBetween(height: AppSpacing.xxlg),
    );
  }
}
