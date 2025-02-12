import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/app.dart';
import 'package:flutter/material.dart';

class ChallengeListPage extends StatelessWidget {
  const ChallengeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      appBar: HomeAppBar(),
      body: Center(
        child: Text('Challenge list'),
      ),
      drawer: AppDrawer(),
    );
  }
}
