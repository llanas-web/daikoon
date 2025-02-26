part of 'notifications_cubit.dart';

class NotificationsState extends Equatable {
  const NotificationsState({required this.notifications});

  const NotificationsState.initial() : this(notifications: const []);

  final List<Notification> notifications;

  @override
  List<Object> get props => [notifications];
}
