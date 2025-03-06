import 'dart:async';

import 'package:animations/animations.dart';
import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/app.dart';
import 'package:daikoon/app/home/home.dart';
import 'package:daikoon/auth/view/auth_page.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/notification/notification.dart';
import 'package:daikoon/user_profile/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

GoRouter router(AppBloc appBloc) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home.route,
    routes: [
      GoRoute(
        path: AppRoutes.auth.route,
        name: AppRoutes.auth.name,
        builder: (context, state) => const AuthPage(),
      ),
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state, navigationShell) => AppPage(
          navigationShell: navigationShell,
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home.route,
                name: AppRoutes.home.name,
                pageBuilder: (context, state) {
                  return CustomTransitionPage(
                    child: const HomePage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) =>
                            SharedAxisTransition(
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      transitionType: SharedAxisTransitionType.horizontal,
                      child: child,
                    ),
                  );
                },
              ),
              GoRoute(
                path: AppRoutes.listChallenges.route,
                name: AppRoutes.listChallenges.name,
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                    key: state.pageKey,
                    child: const ChallengeListPage(),
                  );
                },
              ),
              GoRoute(
                path: AppRoutes.createChallenge.route,
                name: AppRoutes.createChallenge.name,
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                    key: state.pageKey,
                    child: const CreateChallengePage(),
                  );
                },
              ),
              GoRoute(
                path: AppRoutes.challengeDetails.path!,
                name: AppRoutes.challengeDetails.name,
                pageBuilder: (context, state) {
                  final challengeId = state.pathParameters['challengeId'];
                  return NoTransitionPage(
                    key: state.pageKey,
                    child: ChallengeDetailsPage(
                      challengeId: challengeId ?? '',
                    ),
                  );
                },
              ),
            ],
          ),
          generateStatefulShellBranch(route: AppRoutes.search),
          generateStatefulShellBranch(route: AppRoutes.favorite),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.notification.route,
                name: AppRoutes.notification.name,
                pageBuilder: (context, state) {
                  return CustomTransitionPage(
                    child: const NotificationsPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) =>
                            SharedAxisTransition(
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      transitionType: SharedAxisTransitionType.horizontal,
                      child: child,
                    ),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.userProfile.route,
                name: AppRoutes.userProfile.name,
                pageBuilder: (context, state) {
                  final user = context.select(
                    (AppBloc bloc) => bloc.state.user,
                  );
                  return CustomTransitionPage(
                    child: UserProfilePage(userId: user.id),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) =>
                            SharedAxisTransition(
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      transitionType: SharedAxisTransitionType.horizontal,
                      child: child,
                    ),
                  );
                },
                routes: [
                  GoRoute(
                    path: AppRoutes.editProfile.route,
                    name: AppRoutes.editProfile.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => CustomTransitionPage(
                      key: state.pageKey,
                      child: const UserProfileEdit(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              SharedAxisTransition(
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        transitionType: SharedAxisTransitionType.horizontal,
                        child: child,
                      ),
                    ),
                  ),
                  GoRoute(
                    path: AppRoutes.daikoins.route,
                    name: AppRoutes.daikoins.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => CustomTransitionPage(
                      key: state.pageKey,
                      child: const UserProfileDaikoins(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              SharedAxisTransition(
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        transitionType: SharedAxisTransitionType.horizontal,
                        child: child,
                      ),
                    ),
                  ),
                  GoRoute(
                    path: AppRoutes.friends.route,
                    name: AppRoutes.friends.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => CustomTransitionPage(
                      key: state.pageKey,
                      child: const UserProfileFriends(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              SharedAxisTransition(
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        transitionType: SharedAxisTransitionType.horizontal,
                        child: child,
                      ),
                    ),
                  ),
                  GoRoute(
                    path: AppRoutes.addFriends.route,
                    name: AppRoutes.addFriends.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => CustomTransitionPage(
                      key: state.pageKey,
                      child: const UserProfileAddFriend(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              SharedAxisTransition(
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        transitionType: SharedAxisTransitionType.horizontal,
                        child: child,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final authenticated = appBloc.state.status == AppStatus.authenticated;
      final authenticating = state.matchedLocation == AppRoutes.auth.route;
      final isInHome = state.matchedLocation == AppRoutes.home.route;

      if (isInHome && !authenticated) return AppRoutes.auth.route;
      if (!authenticated) return AppRoutes.auth.route;
      if (authenticating && authenticated) return AppRoutes.home.route;

      return null;
    },
    refreshListenable: GoRouterAppBlocRefreshStream(appBloc.stream),
  );
}

/// {@template go_router_refresh_stream}
/// A [ChangeNotifier] that notifies listeners when a [Stream] emits a value.
/// This is used to rebuild the UI when the [AppBloc] emits a new state.
/// {@endtemplate}
class GoRouterAppBlocRefreshStream extends ChangeNotifier {
  /// {@macro go_router_refresh_stream}
  GoRouterAppBlocRefreshStream(Stream<AppState> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((appState) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

StatefulShellBranch generateStatefulShellBranch({
  required AppRoutes route,
}) =>
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: route.route,
          name: route.name,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              child: AppScaffold(
                body: Center(
                  child: Text(route.name, style: context.headlineSmall),
                ),
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      SharedAxisTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
                child: child,
              ),
            );
          },
        ),
      ],
    );
