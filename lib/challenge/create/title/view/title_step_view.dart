import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class TitleStepView extends StatelessWidget {
  const TitleStepView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TitleStepCubit(
        title: context.read<CreateChallengeCubit>().state.title,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            context.l10n.challengeCreationTitleFormLabel,
            style: UITextStyle.title,
          ),
          const TitleForm(),
          const Spacer(),
        ].spacerBetween(height: AppSpacing.xxlg),
      ),
    );
  }
}
