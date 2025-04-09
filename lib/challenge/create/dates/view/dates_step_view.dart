import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class DatesStepView extends StatelessWidget {
  const DatesStepView({super.key});

  @override
  Widget build(BuildContext context) {
    final createChallengeCubit = context.read<CreateChallengeCubit>();
    return BlocProvider(
      create: (_) => DatesStepCubit(
        startDate: createChallengeCubit.state.startDate,
        endDate: createChallengeCubit.state.endDate,
        limitDate: createChallengeCubit.state.limitDate,
      ),
      child: Column(
        children: [
          const Spacer(),
          Text(
            context.l10n.challengeCreationDatesFormLabel,
            style: UITextStyle.title,
          ),
          const Spacer(),
          const DatesForm(),
          const ChallengePreviousButton(),
          const Spacer(),
        ].spacerBetween(height: AppSpacing.xxlg),
      ),
    );
  }
}
