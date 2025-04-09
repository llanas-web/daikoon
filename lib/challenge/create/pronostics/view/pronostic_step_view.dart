import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class PronosticStepView extends StatelessWidget {
  const PronosticStepView({super.key});

  @override
  Widget build(BuildContext context) {
    final existingQuestion =
        context.select((CreateChallengeCubit cubit) => cubit.state.question);
    final existingChoices =
        context.select((CreateChallengeCubit cubit) => cubit.state.choices);
    return BlocProvider(
      create: (context) => PronosticStepCubit(
        question: existingQuestion,
        choices: existingChoices,
      ),
      child: Column(
        children: [
          const Spacer(),
          Text(
            context.l10n.challengeCreationOptionsFormLabel,
            style: UITextStyle.title,
          ),
          const PronosticStepForm(),
          const ChallengePreviousButton(),
          const Spacer(),
        ].spacerBetween(height: AppSpacing.xxlg),
      ),
    );
  }
}
