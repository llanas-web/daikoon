import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:daikoon_blocks_ui/daikoon_blocks_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class DateLimitFormField extends StatelessWidget {
  const DateLimitFormField({super.key});

  @override
  Widget build(BuildContext context) {
    final [startDate, limitDate, endDate] = context.select(
      (DatesStepCubit cubit) =>
          [cubit.state.startDate, cubit.state.limitDate, cubit.state.endDate],
    );
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${context.l10n.challengeCreationDatesLimitFieldLabel} :',
                style: UITextStyle.subtitle,
              ),
              Row(
                children: [
                  Expanded(
                    child: DaikoonFormDateSelector(
                      value: limitDate,
                      hintText:
                          context.l10n.challengeCreationDatesLimitFieldLabel,
                      minDate: startDate ?? DateTime.now(),
                      maxDate: endDate ?? DateTime.now().add(365.days),
                      onDateSelected: (date) {
                        context.read<DatesStepCubit>().onLimitDateChanged(date);
                      },
                    ),
                  ),
                  Expanded(
                    child: DaikoonFormTimeSelector(
                      value: limitDate,
                      hintText:
                          context.l10n.challengeCreationDatesLimitFieldLabel,
                      onTimeSelected:
                          context.read<DatesStepCubit>().onLimitTimeChanged,
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
