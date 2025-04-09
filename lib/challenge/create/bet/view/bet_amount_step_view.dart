import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class BetAmountStepView extends StatelessWidget {
  const BetAmountStepView({super.key});

  @override
  Widget build(BuildContext context) {
    final createChallengeCubit = context.read<CreateChallengeCubit>();
    return BlocProvider(
      create: (context) => BetStepCubit(
        minAmount: createChallengeCubit.state.minAmount,
        maxAmount: createChallengeCubit.state.maxAmount,
        noBetAmount: createChallengeCubit.state.noBetAmount,
      ),
      child: Column(
        children: [
          const Spacer(),
          const BetAmountStepForm(),
          const ChallengePreviousButton(),
          const Spacer(),
        ].spacerBetween(height: AppSpacing.xxlg),
      ),
    );
  }
}
