import 'package:app_ui/app_ui.dart';
import 'package:daikoon/auth/auth.dart';
import 'package:daikoon/auth/sign_up/cubit/sign_up_cubit.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = context
        .select((SignUpCubit bloc) => bloc.state.submissionStatus.isLoading);

    final style = ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(
        context.adaptiveColor,
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          vertical: AppSpacing.xlg,
        ),
      ),
    );

    final child = switch (isLoading) {
      true => AppButton.inProgress(
          style: style,
          scale: 0.5,
          color: context.reversedAdaptiveColor,
        ),
      _ => AppButton.auth(
          context.l10n.signUpButtonLabel,
          () => context.read<SignUpCubit>().onSubmit(onSuccess: () {
            context.read<OtpValidationCubit>().setEmail(
                  context.read<SignUpCubit>().state.email.value,
                );
            context.read<ShowOtpCubit>().changeScreen(showOtp: true);
          }),
          style: style,
          textStyle: UITextStyle.button.copyWith(
            color: context.reversedAdaptiveColor,
          ),
        ),
    };

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: switch (context.screenWidth) {
          > 600 => context.screenWidth * .6,
          _ => context.screenWidth,
        },
      ),
      child: child,
    );
  }
}
