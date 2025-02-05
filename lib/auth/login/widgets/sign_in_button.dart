import 'package:app_ui/app_ui.dart';
import 'package:daikoon/auth/login/login.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.select((LoginCubit bloc) => bloc.state.status.isLoading);

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
          context.l10n.connexionButtonLabel,
          context.read<LoginCubit>().onSubmit,
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
