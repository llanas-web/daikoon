// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:shared/shared.dart';

/// The notification type.
enum NotificationType {
  /// The notification is an invitation.
  invitation('invitation'),

  /// The notification is a challenge started.
  challengeEnded('challenge_ended'),

  /// The notification is a challenge ended.
  newMessage('new_message');

  const NotificationType(this.value);

  /// The value of the notification type.
  final String value;
}

/// The notification status.
enum NotificationStatus {
  /// The notification is an error.
  error('error'),

  /// The notification is pending.
  pending('pending'),

  /// The notification is sent.
  sent('sent'),

  /// The notification is checked.
  checked('checked');

  const NotificationStatus(this.value);

  /// The value of the notification status.
  final String value;
}

/// {@template notification}
/// The representation of the notification.
/// {@endtemplate}
class Notification extends Equatable {
  /// {@macro notification}
  Notification({
    String? id,
    DateTime? createdAt,
    this.title = '',
    this.body = '',
    this.type = NotificationType.invitation,
    this.status = NotificationStatus.pending,
    this.challengeId,
  })  : id = id ?? uuid.v4(),
        createdAt = createdAt ?? Jiffy.now().dateTime;

  /// Converts a `Map<String, dynamic>` json to a [Notification] instance.
  factory Notification.fromJson(Map<String, dynamic> json) {
    final metadatas =
        jsonDecode(json['metadatas'] as String) as Map<String, dynamic>?;

    return Notification(
      id: json['user_id'] as String? ?? json['id'] as String,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      type: (json['type'] as String).toNotificationType ??
          NotificationType.invitation,
      status: (json['status'] as String).toNotificationStatus ??
          NotificationStatus.pending,
      challengeId:
          metadatas != null ? metadatas['challenge_id'] as String? : null,
    );
  }

  /// The notification's generated uuid.
  final String id;

  /// The notification's title.
  final String title;

  /// The notification's body.
  final String body;

  /// The notification's date.
  final DateTime createdAt;

  /// The notification's type.
  final NotificationType type;

  /// The notification's status.
  final NotificationStatus status;

  /// The notification's challenge id.
  final String? challengeId;

  @override
  List<Object> get props =>
      [id, createdAt, title, body, type, status, challengeId ?? ''];
}

/// The notification type extension.
extension NotitifationTypeFromString on String {
  /// Converts a string to a [NotificationType].
  NotificationType? get toNotificationType {
    for (final type in NotificationType.values) {
      if (type.value == this) {
        return type;
      }
    }
    return null;
  }
}

/// The notification status extension.
extension NotificationStatusFromString on String {
  /// Converts a string to a [NotificationStatus].
  NotificationStatus? get toNotificationStatus {
    for (final status in NotificationStatus.values) {
      if (status.value == this) {
        return status;
      }
    }
    return null;
  }
}
