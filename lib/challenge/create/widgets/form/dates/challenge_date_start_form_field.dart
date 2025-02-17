import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/app.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:daikoon_blocks_ui/daikoon_blocks_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class ChallengeDateStartFormField extends StatelessWidget {
  const ChallengeDateStartFormField({super.key});

  @override
  Widget build(BuildContext context) {
    final [startDate, limitDate, endDate] = context.select(
      (CreateChallengeCubit cubit) =>
          [cubit.state.startDate, cubit.state.limitDate, cubit.state.endDate],
    );
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
                      value: startDate,
                      hintText:
                          context.l10n.challengeCreationDatesStartFieldLabel,
                      minDate: DateTime.now(),
                      maxDate:
                          limitDate ?? endDate ?? DateTime.now().add(365.days),
                      onDateSelected: (date) {
                        context
                            .read<CreateChallengeCubit>()
                            .onStartDateChanged(date);
                      },
                    ),
                  ),
                  Expanded(
                    child: DaikoonFormTimeSelector(
                      value: startDate,
                      hintText:
                          context.l10n.challengeCreationDatesStartFieldLabel,
                      onTimeSelected: (time) {
                        try {
                          context
                              .read<CreateChallengeCubit>()
                              .onStartTimeChanged(time);
                        } catch (e) {
                          openSnackbar(
                            SnackbarMessage.error(title: e.toString()),
                          );
                        }
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
