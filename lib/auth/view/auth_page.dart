import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.images.authBackground.image().image,
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.only(top: 262),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                AppColors.primary,
                AppColors.white.withOpacity(0),
              ],
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxlg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image(
                image: Assets.images.daikoonBlury.image().image,
                width: double.infinity,
                color: context.reversedAdaptiveColor,
              ),
              const SizedBox(
                height: AppSpacing.xlg,
              ),
              Row(
                children: [
                  Expanded(
                    child: AppButton.outlined(
                      text: 'Inscription',
                      textStyle: UITextStyle.button.copyWith(
                        color: context.reversedAdaptiveColor,
                      ),
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          context.reversedAdaptiveColor.withOpacity(0.4),
                        ),
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                        ),
                        side: WidgetStateProperty.all(
                          BorderSide(
                            color:
                                context.reversedAdaptiveColor.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: AppSpacing.lg,
              ),
              Row(
                children: [
                  Expanded(
                    child: AppButton.outlined(
                      text: 'Connexion',
                      textStyle: UITextStyle.button.copyWith(
                        color: context.reversedAdaptiveColor,
                      ),
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                        ),
                        side: WidgetStateProperty.all(
                          BorderSide(
                            color:
                                context.reversedAdaptiveColor.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: AppSpacing.xxlg * 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
