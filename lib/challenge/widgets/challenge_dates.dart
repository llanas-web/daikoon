import 'package:app_ui/app_ui.dart';
import 'package:daikoon_blocks_ui/daikoon_blocks_ui.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class ChallengeDates extends StatelessWidget {
  const ChallengeDates({
    required this.title,
    required this.date,
    this.readOnly = false,
    super.key,
  });

  final String title;
  final DateTime date;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: UITextStyle.subtitle,
        ),
        Row(
          children: [
            Expanded(
              child: DaikoonFormDateSelector(
                value: date,
                readOnly: readOnly,
              ),
            ),
            Expanded(
              child: DaikoonFormTimeSelector(
                value: date,
                readOnly: readOnly,
              ),
            ),
          ].spacerBetween(width: AppSpacing.md),
        ),
      ].spacerBetween(height: AppSpacing.md),
    );
  }
}
