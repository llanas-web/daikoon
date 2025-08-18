import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:daikoon/user_profile/user_profile.dart';
import 'package:equatable/equatable.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:shared/shared.dart';
import 'package:storage/storage.dart';
import 'package:user_repository/user_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required User user,
    required UserRepository userRepository,
    required NotificationsRepository notificationRepository,
    required Storage storage,
  })  : _userRepository = userRepository,
        _notificationsRepository = notificationRepository,
        _storage = storage,
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
    on<AppWalletAmountChanged>((event, emit) {
      emit(state.copyWith(userWalletAmount: event.walletAmount));
    });

    _userSubscription =
        userRepository.user.listen(_userChanged, onError: addError);
  }

  final UserRepository _userRepository;
  final NotificationsRepository _notificationsRepository;
  final Storage _storage;

  StreamSubscription<User>? _userSubscription;
  StreamSubscription<String>? _pushTokenSubscription;
  StreamSubscription<List<Notification>>? _notificationSubscription;
  StreamSubscription<int>? _walletSubscription;

  void _userChanged(User user) => add(AppUserChanged(user));

  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) {
    final user = event.user;

    Future<void> authenticate() async {
      emit(AppState.authenticated(user));

      try {
        final isNotificationsEnabled = await _storage.read(
          key: UserProfileStorageKeys.notificationsEnabled,
        );

        if (isNotificationsEnabled != 'false') {
          final pushToken = await _notificationsRepository.fetchToken();
          if (user.pushToken == null || user.pushToken != pushToken) {
            await _userRepository.updateUser(pushToken: pushToken);
          }

          _pushTokenSubscription ??=
              _notificationsRepository.onTokenRefresh().listen(
                    (pushToken) => _userRepository.updateUser(
                      pushToken: pushToken,
                    ),
                  );
        }

        await _userRepository.daikoins(userId: user.id).first.then(
          (walletAmount) {
            add(
              AppWalletAmountChanged(walletAmount: walletAmount),
            );
          },
          onError: addError,
        );

        _walletSubscription ??=
            _userRepository.daikoins(userId: user.id).listen(
          (walletAmount) {
            add(
              AppWalletAmountChanged(
                walletAmount: walletAmount,
              ),
            );
          },
          onError: addError,
        );

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
        {
          if (user.isAnonymous) {
            emit(const AppState.unauthenticated());
            return;
          }
          if (user.isNewUser) {
            emit(AppState.onboardingRequired(user));
            return;
          }
          authenticate();
        }
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
    _walletSubscription?.cancel();
    return super.close();
  }
}
