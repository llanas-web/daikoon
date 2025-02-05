import 'package:app_ui/app_ui.dart';
import 'package:daikoon/auth/login/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const EmailFormField(),
        const PasswordTextField(),
      ].spacerBetween(height: AppSpacing.xxlg),
    );
  }
}
