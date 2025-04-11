import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/view/app.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class PronosticStepForm extends StatelessWidget {
  const PronosticStepForm({super.key});

  @override
  Widget build(BuildContext context) {
    final pronosticCubit = context.select(
      (PronosticStepCubit bloc) => bloc.state,
    );

    void onContinue() {
      if (!context.read<PronosticStepCubit>().validateStep()) {
        openSnackbar(
          SnackbarMessage.error(
            title: 'Formulaire invalide',
            description: pronosticCubit.errorMessage,
          ),
        );
        return;
      }
      context.read<CreateChallengeCubit>().updatePronostic(
            pronosticCubit.challengeQuestion.value,
            pronosticCubit.choices,
          );
      context.read<FormStepperCubit>().nextStep();
    }

    void confirmNewChoice(BuildContext context) => context.confirmAction(
          fn: onContinue,
          title:
              context.l10n.challengeCreationOptionsConfirmationInputChoiceTitle(
            pronosticCubit.newChoiceInput!,
          ),
          noText: context.l10n.cancelText,
          yesText: context
              .l10n.challengeCreationOptionsConfirmationInputChoiceAcceptLabel,
          yesTextStyle: context.labelLarge?.apply(color: AppColors.blue),
        );

    return Column(
      children: [
        const QuestionFormField(),
        const ChoicesForm(),
        ChallengeNextButton(
          onPressed: pronosticCubit.newChoiceInput == null ||
                  pronosticCubit.newChoiceInput!.isEmpty
              ? onContinue
              : () => confirmNewChoice(context),
        ),
      ].spacerBetween(height: AppSpacing.xxlg),
    );
  }
}
