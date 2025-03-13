import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/app.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxlg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withValues(alpha: 0),
            AppColors.primary.withValues(alpha: 0.5),
          ],
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            width: AppSize.cardItemMd,
            child: Text(
              context.l10n.homeHeaderTitle,
              style: context.headlineLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            context.l10n.homeHeaderSubtitle,
            style: context.bodyMedium,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: AppButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        AppColors.secondary,
                      ),
                      padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(
                          vertical: AppSpacing.lg,
                          horizontal: AppSpacing.xxlg,
                        ),
                      ),
                    ),
                    textStyle: UITextStyle.button
                        .copyWith(color: context.reversedAdaptiveColor),
                    text: 'GO !',
                    onPressed: () => context.pushNamed(
                      AppRoutes.createChallenge.name,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  margin: const EdgeInsets.all(AppSpacing.xlg),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.15),
                  ),
                ),
              ),
              Image(
                image: Assets.images.heroImage.provider(),
              ),
            ],
          ),
        ].spacerBetween(height: AppSpacing.xlg),
      ),
    );
  }
}
