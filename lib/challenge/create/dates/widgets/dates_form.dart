import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/view/app.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class DatesForm extends StatelessWidget {
  const DatesForm({super.key});

  @override
  Widget build(BuildContext context) {
    final dateCubit = context.read<DatesStepCubit>();

    void onContinue() {
      if (dateCubit.state.status == DatesStepStatus.failure) {
        openSnackbar(
          SnackbarMessage.error(
            title: 'Formulaire invalide',
            description: dateCubit.state.errorMessage,
          ),
        );
        return;
      }
      context.read<CreateChallengeCubit>().updateDates(
            startDate: dateCubit.state.startDate,
            limitDate: dateCubit.state.limitDate,
            endDate: dateCubit.state.endDate,
          );
      context.read<FormStepperCubit>().nextStep();
    }

    return Column(
      children: [
        const DateStartFormField(),
        const DateLimitFormField(),
        const DateEndFormField(),
        ChallengeNextButton(
          onPressed: onContinue,
        ),
      ].spacerBetween(height: AppSpacing.lg),
    );
  }
}
