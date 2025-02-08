import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/app.dart';
import 'package:daikoon/auth/auth.dart';
import 'package:daikoon/auth/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.submissionStatus.isError) {
          openSnackbar(
            SnackbarMessage.error(
              title:
                  signupSubmissionStatusMessage[state.submissionStatus]!.title,
              description:
                  signupSubmissionStatusMessage[state.submissionStatus]!
                      .description,
            ),
          );
        }
      },
      listenWhen: (previous, current) => previous != current,
      child: Column(
        children: [
          EmailFormField<SignUpCubit, SignUpState>(
            onEmailChanged: (cubit, value) => cubit.onEmailChanged(value),
            onEmailUnfocused: (cubit) => cubit.onEmailUnfocused(),
            emailError: context
                .select((SignUpCubit cubit) => cubit.state.email.errorMessage),
            isLoading: context.select(
              (SignUpCubit cubit) => cubit.state.submissionStatus.isLoading,
            ),
          ),
          const UsernameTextField(),
          PasswordTextField<SignUpCubit, SignUpState>(
            onPasswordChanged: (cubit, value) => cubit.onPasswordChanged(value),
            onPasswordUnfocused: (cubit) => cubit.onPasswordUnfocused(),
            onChangePasswordVisibility: (cubit) =>
                cubit.changePasswordVisibility(),
            passwordError: context.select(
              (SignUpCubit cubit) => cubit.state.password.errorMessage,
            ),
            showPassword: context.select(
              (SignUpCubit cubit) => cubit.state.showPassword,
            ),
            isLoading: context.select(
              (SignUpCubit cubit) => cubit.state.submissionStatus.isLoading,
            ),
          ),
        ].spacerBetween(height: AppSpacing.xlg),
      ),
    );
  }
}
