import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/routes/app_routes.dart';
import 'package:daikoon/notification/notification.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    required this.notification,
    super.key,
  });

  final Notification notification;

  @override
  Widget build(BuildContext context) {
    return Tappable(
      onTap: () {
        context.read<NotificationsCubit>().markAsChecked(notification.id);
        if (notification.challengeId != null) {
          context.goNamed(
            AppRoutes.challengeDetails.name,
            pathParameters: {'challengeId': notification.challengeId!},
          );
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(AppRadius.xxlg),
              border: Border.all(
                color: notification.status != NotificationStatus.checked
                    ? AppColors.secondary
                    : AppColors.borders,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.16),
                  blurRadius: AppRadius.sm,
                  offset: const Offset(0, AppSpacing.xs),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xlg,
              vertical: AppSpacing.lg,
            ),
            height: AppSize.cardItemSm,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  switch (notification.type) {
                    NotificationType.invitation => 'Nouveau Défi 🏆',
                    NotificationType.challengeEnded => 'Défi terminé 📣',
                    NotificationType.newMessage => 'Nouveau message 💬',
                  },
                  style: UITextStyle.notifTypeLabel,
                ),
                Text(
                  notification.title,
                  style: UITextStyle.notifTitle,
                ),
                const ColoredBox(
                  color: AppColors.separators,
                  child: SizedBox(
                    width: 170,
                    height: 1,
                  ),
                ),
                Expanded(
                  child: Text(
                    notification.body,
                    style: UITextStyle.bodyText,
                  ),
                ),
              ].spacerBetween(height: AppSpacing.sm),
            ),
          ),
          if (notification.status != NotificationStatus.checked)
            Positioned(
              top: -5,
              right: -5,
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
