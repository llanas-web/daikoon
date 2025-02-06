import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/app.dart';
import 'package:daikoon/auth/auth.dart';
import 'package:daikoon/auth/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isError) {
          openSnackbar(
            SnackbarMessage.error(
              title: loginSubmissionStatusMessage[state.status]!.title,
              description:
                  loginSubmissionStatusMessage[state.status]!.description,
            ),
          );
        }
      },
      listenWhen: (previous, current) => previous.status != current.status,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EmailFormField<LoginCubit, LoginState>(
            onEmailChanged: (cubit, value) => cubit.onEmailChanged(value),
            onEmailUnfocused: (cubit) => cubit.onEmailUnfocused(),
            emailError: context
                .select((LoginCubit cubit) => cubit.state.email.errorMessage),
            isLoading: context
                .select((LoginCubit cubit) => cubit.state.status.isLoading),
          ),
          PasswordTextField<LoginCubit, LoginState>(
            onPasswordChanged: (cubit, value) => cubit.onPasswordChanged(value),
            onPasswordUnfocused: (cubit) => cubit.onPasswordUnfocused(),
            onChangePasswordVisibility: (cubit) =>
                cubit.changePasswordVisibility(),
            passwordError: context.select(
                (LoginCubit cubit) => cubit.state.password.errorMessage),
            showPassword:
                context.select((LoginCubit cubit) => cubit.state.showPassword),
            isLoading: context
                .select((LoginCubit cubit) => cubit.state.status.isLoading),
          ),
        ].spacerBetween(height: AppSpacing.xxlg),
      ),
    );
  }
}
