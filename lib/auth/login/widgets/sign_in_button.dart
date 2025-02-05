import 'package:app_ui/app_ui.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final child = AppButton(
      text: context.l10n.connexionButtonLabel,
      onPressed: () => logD('Login'),
      textStyle: UITextStyle.button.copyWith(
        color: context.reversedAdaptiveColor,
        letterSpacing: 1.2,
      ),
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          context.adaptiveColor,
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(
            vertical: AppSpacing.xlg,
          ),
        ),
      ),
    );

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: switch (context.screenWidth) {
          > 600 => context.screenWidth * .6,
          _ => context.screenWidth,
        },
      ),
      child: child,
    );
  }
}
