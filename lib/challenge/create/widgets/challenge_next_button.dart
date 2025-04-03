import 'package:app_ui/app_ui.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';

class ChallengeNextButton extends StatelessWidget {
  const ChallengeNextButton({
    required this.onPressed,
    this.enable = true,
    super.key,
  });

  final VoidCallback onPressed;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    final style = ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(
        enable ? AppColors.primary : AppColors.primary.withValues(alpha: 0.5),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          vertical: AppSpacing.lg,
          horizontal: AppSpacing.xxlg,
        ),
      ),
    );
    final textStyle =
        UITextStyle.button.copyWith(color: context.reversedAdaptiveColor);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: AppButton(
              style: style,
              textStyle: textStyle,
              text: context.l10n.challengeCreationContinueButtonLabel,
              onPressed: onPressed,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      context.l10n.challengeCreationContinueButtonLabel,
                      style: textStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: AppSize.iconSizeMedium,
                    color: context.reversedAdaptiveColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
