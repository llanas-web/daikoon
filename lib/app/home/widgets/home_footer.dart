import 'package:app_ui/app_ui.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';

class HomeFooter extends StatelessWidget {
  const HomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.lightGrey,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
      ),
      child: Text(
        context.l10n.homeFooterLabel,
        style: UITextStyle.bodyText.copyWith(
          color: AppColors.grey,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
