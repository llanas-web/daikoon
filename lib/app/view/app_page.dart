import 'package:app_ui/app_ui.dart';
import 'package:daikoon/navigation/navigation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class AppPage extends StatelessWidget {
  const AppPage({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavBar(
        navigationShell: navigationShell,
      ),
    );
  }
}
