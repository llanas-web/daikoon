import 'dart:async';
import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:bloc/bloc.dart';
import 'package:daikoon/app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_notifications_client/firebase_notifications_client.dart';
import 'package:flutter/widgets.dart';
import 'package:powersync_repository/powersync_repository.dart';
import 'package:shared/shared.dart';

typedef AppBuilder = FutureOr<Widget> Function(
  PowerSyncRepository,
  FirebaseMessaging,
);

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    logD('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    logD('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  logI('Handling a background message: ${message.toMap()}');
}

Future<void> bootstrap(
  AppBuilder builder, {
  required FirebaseOptions options,
  required AppFlavor appFlavor,
}) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    setupDi(appFlavor: appFlavor);

    await Firebase.initializeApp(
      options: options,
    );

    final powerSyncRepository = PowerSyncRepository(env: appFlavor.getEnv);
    await powerSyncRepository.initialize();

    final firebaseMessaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHandler,
    );

    SystemUiOverlayTheme.setPortraitOrientation();

    runApp(await builder(powerSyncRepository, firebaseMessaging));
  }, (error, stack) {
    logE(error.toString(), stackTrace: stack);
  });
}
