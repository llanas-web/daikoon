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
    final titleCubit = context.read<DatesStepCubit>();

    void onContinue() {
      switch (titleCubit.state.status) {
        case DatesStepStatus.initial:
          break;
        case DatesStepStatus.failure:
          openSnackbar(
            SnackbarMessage.error(
              title: 'Formulaire invalide',
              description: titleCubit.state.errorMessage,
            ),
          );
        case DatesStepStatus.success:
          context.read<CreateChallengeCubit>().updateDates(
                startDate: titleCubit.state.startDate,
                endDate: titleCubit.state.endDate,
                limitDate: titleCubit.state.limitDate,
              );
          context.read<FormStepperCubit>().nextStep();
      }
    }

    return Column(
      children: [
        const DateStartFormField(),
        const DateLimitFormField(),
        const DateEndFormField(),
        ChallengeNextButton(
          enable: titleCubit.state.status != DatesStepStatus.initial,
          onPressed: onContinue,
        ),
      ].spacerBetween(height: AppSpacing.lg),
    );
  }
}
