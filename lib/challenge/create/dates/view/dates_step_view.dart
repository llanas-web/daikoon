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
    return BlocProvider(
      create: (_) => context.read<DatesStepCubit>(),
      child: Column(
        children: [
          Text(
            context.l10n.challengeCreationDatesFormLabel,
            style: UITextStyle.title,
          ),
          Column(
            children: [
              const DateStartFormField(),
              const DateLimitFormField(),
              const DateEndFormField(),
            ].spacerBetween(height: AppSpacing.lg),
          ),
        ].spacerBetween(height: AppSpacing.xxlg),
      ),
    );
  }
}
