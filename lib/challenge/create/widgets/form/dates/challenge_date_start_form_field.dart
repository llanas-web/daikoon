import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:daikoon_blocks_ui/daikoon_blocks_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class ChallengeDateStartFormField extends StatefulWidget {
  const ChallengeDateStartFormField({super.key});

  @override
  State<ChallengeDateStartFormField> createState() =>
      _ChallengeDateStartFormFieldState();
}

class _ChallengeDateStartFormFieldState
    extends State<ChallengeDateStartFormField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${context.l10n.challengeCreationDatesStartFieldLabel} :',
              ),
              Row(
                children: [
                  Expanded(
                    child: DaikoonFormDateSelector(
                      hintText:
                          context.l10n.challengeCreationDatesStartFieldLabel,
                      minDate: DateTime.now(),
                      maxDate: DateTime.now().add(const Duration(days: 365)),
                      onDateSelected: (date) {
                        context
                            .read<CreateChallengeCubit>()
                            .onStartDateChanged(date);
                      },
                    ),
                  ),
                  Expanded(
                    child: DaikoonFormDateSelector(
                      hintText:
                          context.l10n.challengeCreationDatesStartFieldLabel,
                      minDate: DateTime.now(),
                      maxDate: DateTime.now().add(const Duration(days: 365)),
                      onDateSelected: (date) {
                        context
                            .read<CreateChallengeCubit>()
                            .onStartDateChanged(date);
                      },
                    ),
                  ),
                ].spacerBetween(width: AppSpacing.md),
              ),
            ].spacerBetween(height: AppSpacing.sm),
          ),
        ),
      ],
    );
  }
}
