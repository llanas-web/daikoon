import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:shared/shared.dart';
import 'package:user_repository/user_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required User user,
    required UserRepository userRepository,
    required NotificationsRepository notificationRepository,
  })  : _userRepository = userRepository,
        _notificationsRepository = notificationRepository,
        super(
          user.isAnonymous
              ? const AppState.unauthenticated()
              : AppState.authenticated(user),
        ) {
    on<AppLogoutRequested>(_onAppLogoutRequested);
    on<AppUserChanged>(_onUserChanged);
    on<AppNotificationChanged>((event, emit) {
      emit(state.copyWith(hasNotification: event.hasNotification));
    });

    _userSubscription =
        userRepository.user.listen(_userChanged, onError: addError);
  }

  final UserRepository _userRepository;
  final NotificationsRepository _notificationsRepository;

  StreamSubscription<User>? _userSubscription;
  StreamSubscription<String>? _pushTokenSubscription;
  StreamSubscription<List<Notification>>? _notificationSubscription;

  void _userChanged(User user) => add(AppUserChanged(user));

  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) {
    final user = event.user;

    Future<void> authenticate() async {
      emit(AppState.authenticated(user));

      try {
        final pushToken = await _notificationsRepository.fetchToken();
        if (user.pushToken == null || user.pushToken != pushToken) {
          await _userRepository.updateUser(pushToken: pushToken);
        }

        _pushTokenSubscription ??=
            _notificationsRepository.onTokenRefresh().listen((pushToken) async {
          await _userRepository.updateUser(pushToken: pushToken);
        });

        _notificationSubscription =
            _notificationsRepository.notificationsOf(userId: user.id).listen(
          (listNotifications) {
            add(
              AppNotificationChanged(
                hasNotification: listNotifications.any(
                  (notification) =>
                      notification.status != NotificationStatus.checked,
                ),
              ),
            );
          },
          onError: addError,
        );

        unawaited(_notificationsRepository.requestPermission());
      } catch (error, stackTrace) {
        addError(error, stackTrace);
      }
    }

    switch (state.status) {
      case AppStatus.onboardingRequired:
      case AppStatus.authenticated:
      case AppStatus.unauthenticated:
        return !user.isAnonymous && user.isNewUser
            ? emit(AppState.onboardingRequired(user))
            : user.isAnonymous
                ? emit(const AppState.unauthenticated())
                : authenticate();
    }
  }

  Future<void> _onAppLogoutRequested(
    AppLogoutRequested event,
    Emitter<AppState> emit,
  ) =>
      _userRepository.logOut();

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    _pushTokenSubscription?.cancel();
    _notificationSubscription?.cancel();
    return super.close();
  }
}
