import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChallengeNextButton extends StatelessWidget {
  const ChallengeNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const style = ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(
        AppColors.primary,
      ),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          vertical: AppSpacing.lg,
          horizontal: AppSpacing.xxlg,
        ),
      ),
    );
    final textStyle =
        UITextStyle.button.copyWith(color: context.reversedAdaptiveColor);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: AppButton(
              style: style,
              textStyle: textStyle,
              text: context.l10n.challengeCreationContinueButtonLabel,
              onPressed: () {
                final formIndex = context.read<FormStepperCubit>().state;
                if (context
                    .read<CreateChallengeCubit>()
                    .isCurrentFormValid(formIndex)) {
                  context.read<FormStepperCubit>().nextStep();
                }
              },
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      context.l10n.challengeCreationContinueButtonLabel,
                      style: textStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: AppSize.iconSizeMedium,
                    color: context.reversedAdaptiveColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
