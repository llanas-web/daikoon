import 'package:app_ui/app_ui.dart';
import 'package:daikoon/auth/login/widgets/conditions_infos.dart';
import 'package:daikoon/auth/login/widgets/login_form.dart';
import 'package:daikoon/auth/login/widgets/widgets.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColors.deepBlue,
      releaseFocus: true,
      resizeToAvoidBottomInset: true,
      body: AppConstrainedScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxlg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Gap.v(AppSpacing.xxxlg * 2),
            const AppLogo(
              height: AppSpacing.xxxlg,
              fit: BoxFit.fitHeight,
              width: double.infinity,
            ),
            const Gap.v(AppSpacing.sm),
            Text(
              context.l10n.connexionButtonLabel,
              style: UITextStyle.screenLabel.copyWith(
                color: context.customReversedAdaptiveColor(
                  light: AppColors.primary,
                ),
                letterSpacing: AppSpacing.md,
              ),
            ),
            const Gap.v(AppSpacing.xxlg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '* ${context.l10n.requiredFieldLabel}',
                    style: UITextStyle.caption.copyWith(
                      color: context.reversedAdaptiveColor,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.end,
                  ),
                  const LoginForm(),
                  Tappable(
                    child: Text(
                      context.l10n.forgotPasswordButtonLabel,
                      style: UITextStyle.caption.copyWith(
                        color: context.reversedAdaptiveColor,
                        decoration: TextDecoration.underline,
                        decorationColor: context.reversedAdaptiveColor,
                      ),
                    ),
                  ),
                  const Align(
                    child: SignInButton(),
                  ),
                ].spacerBetween(height: AppSpacing.xxlg),
              ),
            ),
            const ConditionsInfos(),
          ],
        ),
      ),
    );
  }
}
