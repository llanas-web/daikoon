import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () =>
              context.read<AppBloc>().add(const AppLogoutRequested()),
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
