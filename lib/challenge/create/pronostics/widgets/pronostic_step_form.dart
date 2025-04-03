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
      switch (pronosticCubit.status) {
        case PronosticStepStatus.initial:
          break;
        case PronosticStepStatus.error:
          openSnackbar(
            SnackbarMessage.error(
              title: 'Formulaire invalide',
              description: pronosticCubit.errorMessage,
            ),
          );
        case PronosticStepStatus.success:
          context.read<CreateChallengeCubit>().updateTitle(
                pronosticCubit.challengeQuestion.value,
              );
          context.read<FormStepperCubit>().nextStep();
      }
    }

    return Column(
      children: [
        Text(
          context.l10n.challengeCreationOptionsFormLabel,
          style: UITextStyle.title,
        ),
        const QuestionFormField(),
        const ChoicesForm(),
        ChallengeNextButton(onPressed: onContinue),
      ].spacerBetween(height: AppSpacing.xxlg),
    );
  }
}
