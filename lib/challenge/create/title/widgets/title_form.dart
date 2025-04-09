import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/view/app.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class TitleForm extends StatelessWidget {
  const TitleForm({super.key});

  @override
  Widget build(BuildContext context) {
    final titleCubit = context.select((TitleStepCubit bloc) => bloc.state);

    void onContinue() {
      if (!context.read<TitleStepCubit>().validateStep()) {
        openSnackbar(
          SnackbarMessage.error(
            title: 'Formulaire invalide',
            description: titleCubit.errorMessage,
          ),
        );
        return;
      }
      context.read<CreateChallengeCubit>().updateTitle(
            titleCubit.challengeTitle.value,
          );
      context.read<FormStepperCubit>().nextStep();
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TitleFormField(
                onSubmit: onContinue,
              ),
            ),
          ],
        ),
        ChallengeNextButton(
          enable: titleCubit.status != TitleStepStatus.initial,
          onPressed: onContinue,
        ),
      ].spacerBetween(height: AppSpacing.xxlg),
    );
  }
}
