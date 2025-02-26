import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:shared/shared.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({
    required NotificationsRepository notificationsRepository,
  })  : _notificationsRepository = notificationsRepository,
        super(const NotificationsState.initial());

  final NotificationsRepository _notificationsRepository;

  /// Emits initial state of notifications screen.
  void resetState() => emit(const NotificationsState.initial());

  /// Fetches notifications from repository and emits new state.
  /// If fetching notifications fails, an error is thrown.
  Stream<List<Notification>> fetchNotifications({
    required String userId,
  }) {
    return _notificationsRepository.notificationsOf(userId: userId);
  }

  Future<void> markAsChecked(String notificationId) async {
    await _notificationsRepository.markAsChecked(notificationId);
  }
}
