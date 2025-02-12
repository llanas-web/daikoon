import 'package:app_ui/app_ui.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';

class ChallengeNextButton extends StatelessWidget {
  const ChallengeNextButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            text: context.l10n.challengeCreationContinueButtonLabel,
            onPressed: onPressed,
          ),
        ),
      ],
    );
  }
}
