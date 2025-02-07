import 'package:animations/animations.dart';
import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/app.dart';
import 'package:daikoon/app/home/home.dart';
import 'package:daikoon/auth/view/auth_page.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

GoRouter router() {
  return GoRouter(
    initialLocation: AppRoutes.home.route,
    routes: [
      GoRoute(
        path: AppRoutes.auth.route,
        name: AppRoutes.auth.name,
        builder: (context, state) => const AuthPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => HomePage(
          navigationShell: navigationShell,
        ),
        branches: [
          generateStatefulShellBranch(route: AppRoutes.home),
          generateStatefulShellBranch(route: AppRoutes.search),
          generateStatefulShellBranch(route: AppRoutes.favorite),
          generateStatefulShellBranch(route: AppRoutes.notification),
          generateStatefulShellBranch(route: AppRoutes.userProfile),
        ],
      ),
    ],
  );
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
                body: Text(route.name, style: context.headlineSmall),
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
