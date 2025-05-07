import 'package:app_ui/app_ui.dart';
import 'package:challenge_repository/challenge_repository.dart';
import 'package:daikoon/app/app.dart';
import 'package:daikoon/app/view/app_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:storage/storage.dart';
import 'package:user_repository/user_repository.dart';

final snackbarKey = GlobalKey<AppSnackbarState>();

class App extends StatelessWidget {
  const App({
    required this.user,
    required this.userRepository,
    required this.notificationsRepository,
    required this.challengeRepository,
    required this.storage,
    super.key,
  });

  final User user;
  final UserRepository userRepository;
  final NotificationsRepository notificationsRepository;
  final ChallengeRepository challengeRepository;
  final Storage storage;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: userRepository),
        RepositoryProvider.value(value: challengeRepository),
        RepositoryProvider.value(value: notificationsRepository),
        RepositoryProvider.value(value: storage),
      ],
      child: BlocProvider(
        create: (context) => AppBloc(
          userRepository: userRepository,
          notificationRepository: notificationsRepository,
          user: user,
          storage: storage,
        ),
        child: const AppView(),
      ),
    );
  }
}

/// Snack bar to show messages to the user.
void openSnackbar(
  SnackbarMessage message, {
  bool clearIfQueue = false,
  bool undismissable = false,
}) {
  snackbarKey.currentState
      ?.post(message, clearIfQueue: clearIfQueue, undismissable: undismissable);
}

/// Closes all snack bars.
void closeSnackbars() => snackbarKey.currentState?.closeAll();

void showCurrentlyUnavailableFeature({bool clearIfQueue = true}) =>
    openSnackbar(
      const SnackbarMessage.error(
        title: 'Feature is not available!',
        description:
            'We are trying our best to implement it as fast as possible.',
        icon: Icons.error_outline,
      ),
      clearIfQueue: clearIfQueue,
    );
