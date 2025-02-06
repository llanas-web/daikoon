import 'package:app_ui/app_ui.dart';
import 'package:daikoon/auth/auth.dart';
import 'package:daikoon/auth/sign_up/cubit/sign_up_cubit.dart';
import 'package:daikoon/auth/sign_up/widgets/username_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EmailFormField<SignUpCubit, SignUpState>(
          onEmailChanged: (cubit, value) => cubit.onEmailChanged(value),
          onEmailUnfocused: (cubit) => cubit.onEmailUnfocused(),
          emailError: context
              .select((SignUpCubit cubit) => cubit.state.email.errorMessage),
          isLoading: context.select(
              (SignUpCubit cubit) => cubit.state.submissionStatus.isLoading),
        ),
        const UsernameTextField(),
        PasswordTextField<SignUpCubit, SignUpState>(
          onPasswordChanged: (cubit, value) => cubit.onPasswordChanged(value),
          onPasswordUnfocused: (cubit) => cubit.onPasswordUnfocused(),
          onChangePasswordVisibility: (cubit) =>
              cubit.changePasswordVisibility(),
          passwordError: context
              .select((SignUpCubit cubit) => cubit.state.password.errorMessage),
          showPassword:
              context.select((SignUpCubit cubit) => cubit.state.showPassword),
          isLoading: context.select(
              (SignUpCubit cubit) => cubit.state.submissionStatus.isLoading),
        ),
      ].spacerBetween(height: AppSpacing.xlg),
    );
  }
}
