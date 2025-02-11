import 'package:app_ui/app_ui.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';

class UserProfileEditSaveButton extends StatelessWidget {
  const UserProfileEditSaveButton({
    required this.onPressed,
    super.key,
  });

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      textStyle: UITextStyle.button.copyWith(
        color: context.reversedAdaptiveColor,
      ),
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(
            vertical: AppSpacing.md * 1.5,
          ),
        ),
        backgroundColor: WidgetStateProperty.all(
          AppColors.secondary,
        ),
      ),
      onPressed: onPressed,
      text: context.l10n.saveText,
    );
  }
}
