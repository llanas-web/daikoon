import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      appBar: HomeAppBar(),
      body: Center(
        child: Text('home'),
      ),
      drawer: AppDrawer(),
    );
  }
}
