import 'package:app_ui/app_ui.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:daikoon_blocks_ui/daikoon_blocks_ui.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class ChallengeItem extends StatelessWidget {
  const ChallengeItem({required this.challenge, super.key});

  final Challenge challenge;

  @override
  Widget build(BuildContext context) {
    return Tappable(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(AppRadius.xxlg),
          border: Border.all(
            color: AppColors.primary,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.5),
              blurRadius: AppRadius.xlg,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xlg,
          vertical: AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (challenge.isPending) const Text('Défi en cours ⏱️'),
            if (challenge.isEnded) const Text('Défi terminé 📣'),
            if (!challenge.isStarted) const Text('Nouveau Défi 🏆'),
            Text(
              challenge.title ?? '',
              style: context.headlineMedium?.copyWith(
                fontWeight: AppFontWeight.extraBold,
              ),
            ),
            const Divider(color: AppColors.primary),
            Text('Défi organisé par ${challenge.creator?.username}'),
            const Gap.v(AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${context.l10n.challengeCreationDatesEndFieldLabel} :',
                  style: context.titleMedium?.copyWith(
                    fontWeight: AppFontWeight.extraBold,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: DaikoonFormDateSelector(
                        value: challenge.ending,
                        hintText: 'Date de fin',
                        readOnly: true,
                      ),
                    ),
                    Expanded(
                      child: DaikoonFormTimeSelector(
                        value: challenge.ending,
                        hintText: 'Heure de fin',
                        readOnly: true,
                      ),
                    ),
                  ].spacerBetween(width: AppSpacing.md),
                ),
              ].spacerBetween(height: AppSpacing.sm),
            ),
          ].spacerBetween(height: AppSpacing.sm),
        ),
      ),
    );
  }
}
