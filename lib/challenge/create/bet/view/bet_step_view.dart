import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:flutter/widgets.dart';
import 'package:shared/shared.dart';

class BetStepView extends StatelessWidget {
  const BetStepView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        const BetForm(),
        const ChallengePreviousButton(),
        const Spacer(),
      ].spacerBetween(height: AppSpacing.xxlg),
    );
  }
}
