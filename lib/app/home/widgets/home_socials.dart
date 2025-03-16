import 'package:app_ui/app_ui.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class HomeSocials extends StatelessWidget {
  const HomeSocials({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.xxlg),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(38),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey.withValues(alpha: 0.2),
                    offset: const Offset(0, 3),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(38),
                      child: ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          AppColors.primary,
                          BlendMode.modulate,
                        ),
                        child: Assets.images.portraitMannequinFemmeNeon
                            .image(fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Assets.images.daikoon.svg(
                        width: context.screenWidth / 2,
                        colorFilter: const ColorFilter.mode(
                          AppColors.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xlg),
            child: Text(
              context.l10n.homeSocialsTitle,
              style: UITextStyle.title,
              textAlign: TextAlign.center,
            ),
          ),
          const AppDivider(
            color: AppColors.lightGrey,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.xxlg,
                ),
                child: Assets.images.daikoon.svg(
                  width: context.screenWidth / 2,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    'Liens utiles',
                    style: UITextStyle.titleSmallBold,
                  ),
                  Container(
                    width: 30,
                    color: AppColors.lightGrey,
                    height: 3,
                  ),
                  Text(
                    'FAQ',
                    style: UITextStyle.subtitle,
                  ),
                  Text(
                    'Mentions légales',
                    style: UITextStyle.subtitle,
                  ),
                  Text(
                    'Politiques de confidentialité',
                    style: UITextStyle.subtitle,
                  ),
                  Text(
                    'CGV',
                    style: UITextStyle.subtitle,
                  ),
                  Text(
                    'Qui sommes nous ?',
                    style: UITextStyle.subtitle,
                  ),
                ].spacerBetween(height: AppSpacing.md),
              ),
              Column(
                children: [
                  Text(
                    'Mon espace',
                    style: UITextStyle.titleSmallBold,
                  ),
                  Container(
                    width: 30,
                    color: AppColors.lightGrey,
                    height: 3,
                  ),
                  Text(
                    'Mon compte',
                    style: UITextStyle.subtitle,
                  ),
                  Text(
                    'Service client',
                    style: UITextStyle.subtitle,
                  ),
                ].spacerBetween(height: AppSpacing.md),
              ),
              Column(
                children: [
                  Text(
                    'Contact',
                    style: UITextStyle.titleSmallBold,
                  ),
                  Container(
                    width: 30,
                    color: AppColors.lightGrey,
                    height: 3,
                  ),
                  Text(
                    'Nous contacter',
                    style: UITextStyle.subtitle,
                  ),
                ].spacerBetween(height: AppSpacing.md),
              ),
            ].spacerBetween(height: AppSpacing.xlg),
          ),
        ].spacerBetween(height: AppSpacing.xlg),
      ),
    );
  }
}
