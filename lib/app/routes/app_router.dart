import 'package:daikoon/app/app.dart';
import 'package:daikoon/auth/view/auth_page.dart';
import 'package:go_router/go_router.dart';

GoRouter router() {
  return GoRouter(
    initialLocation: AppRoutes.auth.route,
    routes: [
      GoRoute(
        path: AppRoutes.auth.route,
        name: AppRoutes.auth.name,
        builder: (context, state) => const AuthPage(),
      ),
    ],
  );
}
