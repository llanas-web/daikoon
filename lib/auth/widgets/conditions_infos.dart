import 'package:app_ui/app_ui.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';

class ConditionsInfos extends StatelessWidget {
  const ConditionsInfos({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.conditionsLabel,
      textAlign: TextAlign.center,
      style: ContentTextStyle.labelSmall.copyWith(
        color: context.reversedAdaptiveColor,
      ),
    );
  }
}
