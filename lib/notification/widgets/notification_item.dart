import 'package:flutter/material.dart' hide Notification;
import 'package:shared/shared.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    required this.notification,
    super.key,
  });

  final Notification notification;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(notification.title),
      subtitle: Text(notification.body),
    );
  }
}
