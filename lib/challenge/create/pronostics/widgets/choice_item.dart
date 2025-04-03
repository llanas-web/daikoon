import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChoiceItem extends StatelessWidget {
  const ChoiceItem({required this.choice, super.key});

  final String choice;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              color: AppColors.white,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.lg,
              horizontal: AppSpacing.xlg,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  choice,
                  style: UITextStyle.subtitle.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                Tappable(
                  onTap: () => context
                      .read<PronosticStepCubit>()
                      .onChoicesRemoved(choice),
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
