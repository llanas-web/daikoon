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
          context.pushNamed(
            AppRoutes.challengeDetails.name,
            pathParameters: {'challengeId': notification.challengeId!},
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(AppRadius.xxlg),
          border: Border.all(
            color: notification.status != NotificationStatus.checked
                ? AppColors.secondary
                : Colors.transparent,
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
        height: AppSize.cardItemSm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              switch (notification.type) {
                NotificationType.invitation => 'Nouveau Défi 🏆',
                NotificationType.challengeEnded => 'Défi terminé 📣',
                NotificationType.newMessage => 'Nouveau message 💬',
              },
            ),
            Text(
              notification.title,
              style: context.headlineMedium?.copyWith(
                fontWeight: AppFontWeight.extraBold,
              ),
            ),
            Expanded(
              child: Text(
                notification.body,
                style: UITextStyle.subtitle2,
              ),
            ),
          ].spacerBetween(height: AppSpacing.sm),
        ),
      ),
    );
  }
}
