import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class ChoicesForm extends StatelessWidget {
  const ChoicesForm({super.key});

  @override
  Widget build(BuildContext context) {
    final choices = context.select(
      (PronosticStepCubit cubit) => cubit.state.choices,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${context.l10n.challengeCreationOptionsFormFieldLabel} :',
          style: UITextStyle.subtitle,
        ),
        if (choices.isNotEmpty)
          Column(
            children: choices
                .map((choice) => ChoiceItem(choice: choice))
                .toList()
                .spacerBetween(height: AppSpacing.md),
          ),
        const Gap.v(AppSpacing.md),
        const ChoiceFormField(),
      ].spacerBetween(height: AppSpacing.md),
    );
  }
}
