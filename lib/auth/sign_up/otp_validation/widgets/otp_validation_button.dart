import 'package:app_ui/app_ui.dart';
import 'package:daikoon/auth/auth.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpValidationButton extends StatelessWidget {
  const OtpValidationButton({super.key});

  @override
  Widget build(BuildContext context) {
    final style = ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(context.adaptiveColor),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
    final isLoading = context
        .select((OtpValidationCubit cubit) => cubit.state.status.isLoading);
    final child = switch (isLoading) {
      true => AppButton.inProgress(style: style, scale: 0.5),
      _ => AppButton.auth(
          context.l10n.signUpOtpValidationButtonLabel,
          () => context.read<OtpValidationCubit>().onSubmit(),
          style: style,
          textStyle: TextStyle(
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
