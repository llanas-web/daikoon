import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/app.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/challenge/create/title/cubit/title_step_cubit.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class TitleStepView extends StatelessWidget {
  const TitleStepView({super.key});

  @override
  Widget build(BuildContext context) {
    final titleCubit = context.select((TitleStepCubit bloc) => bloc.state);

    void onContinue() {
      switch (titleCubit.status) {
        case TitleStepStatus.initial:
          break;
        case TitleStepStatus.error:
          openSnackbar(
            SnackbarMessage.error(
              title: 'Formulaire invalide',
              description: titleCubit.errorMessage,
            ),
          );
        case TitleStepStatus.success:
          context.read<CreateChallengeCubit>().updateTitle(
                titleCubit.challengeTitle.value,
              );
          context.read<FormStepperCubit>().nextStep();
      }
    }

    return BlocProvider(
      create: (context) => TitleStepCubit(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Column(
            children: [
              Text(
                context.l10n.challengeCreationTitleFormLabel,
                style: UITextStyle.title,
              ),
              Row(
                children: [
                  Expanded(
                    child: ChallengeTitleFormField(
                      onSubmit: onContinue,
                    ),
                  ),
                ],
              ),
            ].spacerBetween(height: AppSpacing.xxlg),
          ),
          ChallengeNextButton(
            enable: titleCubit.status != TitleStepStatus.initial,
            onPressed: onContinue,
          ),
          const Spacer(),
        ].spacerBetween(height: AppSpacing.xxlg),
      ),
    );
  }
}
