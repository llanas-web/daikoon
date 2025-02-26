import 'package:database_client/database_client.dart';
import 'package:notifications_client/notifications_client.dart';
import 'package:shared/shared.dart';

/// {@template notifications_repository}
/// A repository that manages notification permissions and token fetching.
/// {@endtemplate}
class NotificationsRepository {
  /// {@macro notifications_repository}
  const NotificationsRepository({
    required DatabaseClient databaseClient,
    required NotificationsClient notificationsClient,
  })  : _databaseClient = databaseClient,
        _notificationsClient = notificationsClient;

  final NotificationsClient _notificationsClient;
  final DatabaseClient _databaseClient;

  /// Returns a stream that emits a new token whenever the token is refreshed.
  Stream<String> onTokenRefresh() => _notificationsClient.onTokenRefresh();

  /// Requests permission to send notifications.
  /// If permission is granted, the method resolves successfully.
  /// If permission is denied, an error is thrown.
  Future<void> requestPermission() async {
    try {
      await _notificationsClient.requestPermission();
    } on RequestPermissionFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(RequestPermissionFailure(error), stackTrace);
    }
  }

  /// Fetches the current notification token.
  /// If fetching the token fails, an error is thrown.
  Future<String?> fetchToken() async {
    try {
      return _notificationsClient.fetchToken();
    } on FetchTokenFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(FetchTokenFailure(error), stackTrace);
    }
  }

  /// Returns a list of notifications associated with the provided [userId].
  Stream<List<Notification>> notificationsOf({required String userId}) {
    return _databaseClient.notificationsOf(userId: userId);
  }

  /// Marks the notification with the provided [notificationId] as checked.
  Future<void> markAsChecked(String notificationId) async {
    await _databaseClient.markAsChecked(notificationId);
  }
}
