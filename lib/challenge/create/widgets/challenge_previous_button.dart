import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/create/cubit/form_stepper_cubit.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChallengePreviousButton extends StatelessWidget {
  const ChallengePreviousButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Tappable(
      child: Text(
        '< ${context.l10n.challengeCreationCancelButtonLabel}',
        textAlign: TextAlign.center,
        style: UITextStyle.subtitle.copyWith(
          decoration: TextDecoration.underline,
          color: AppColors.primary,
        ),
      ),
      onTap: () => context.read<FormStepperCubit>().previousStep(),
    );
  }
}
