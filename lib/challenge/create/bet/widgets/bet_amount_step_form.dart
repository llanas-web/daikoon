import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/view/app.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:daikoon_blocks_ui/daikoon_blocks_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class BetAmountStepForm extends StatelessWidget {
  const BetAmountStepForm({super.key});

  @override
  Widget build(BuildContext context) {
    final betStepCubit = context.select((BetStepCubit cubit) => cubit.state);

    void onNoBetAmount() {
      FocusScope.of(context).requestFocus(FocusNode());
      context.read<BetStepCubit>().onNoBetAmountChanged(noBetAmount: true);
    }

    void onContinue() {
      if (!context.read<BetStepCubit>().validateStep()) {
        openSnackbar(
          SnackbarMessage.error(
            title: 'Formulaire invalide',
            description: betStepCubit.errorMessage,
          ),
        );
        return;
      }
      context.read<CreateChallengeCubit>().updateBetAmount(
            minAmount: betStepCubit.minAmount,
            maxAmount: betStepCubit.maxAmount,
            noBetAmount: betStepCubit.noBetAmount,
          );
      context.read<FormStepperCubit>().nextStep();
    }

    return Column(
      children: [
        Column(
          children: [
            Row(
              children: [
                const MinAmountFormField(),
                const Gap.h(AppSpacing.xlg),
                MaxAmountFormField(
                  onSubmit: onContinue,
                ),
              ],
            ),
            const Gap.v(AppSpacing.md),
            DaikoonFormRadioItem(
              title:
                  context.l10n.challengeCreationBetAmountNoLimitFormFieldLabel,
              onTap: onNoBetAmount,
              isSelected: betStepCubit.noBetAmount,
            ),
          ],
        ),
        ChallengeNextButton(
          onPressed: onContinue,
        ),
      ].spacerBetween(height: AppSpacing.xxlg),
    );
  }
}
