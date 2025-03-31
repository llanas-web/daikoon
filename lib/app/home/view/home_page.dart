import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/home/home.dart';
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
    return AppScaffold(
      appBar: const HomeAppBar(),
      body: AppConstrainedScrollView(
        withScrollBar: true,
        child: Column(
          children: [
            const HomeHeader(),
            const HomePartners(),
            Transform.translate(
              offset: const Offset(0, -50),
              child: const HomeSocials(),
            ),
            const HomeFooter(),
          ],
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
