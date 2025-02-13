import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class ChallengeTitleTextField extends StatefulWidget {
  const ChallengeTitleTextField({super.key});

  @override
  State<ChallengeTitleTextField> createState() =>
      _ChallengeTitleTextFieldState();
}

class _ChallengeTitleTextFieldState extends State<ChallengeTitleTextField> {
  final _debouncer = Debouncer();

  @override
  Widget build(BuildContext context) {
    final challengeTitle = context.select(
      (CreateChallengeCubit cubit) => cubit.state.challengeTitle,
    );
    return AppTextField(
      contentPadding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.xlg,
      ),
      hintText: context.l10n.challengeCreationTitleFormFieldHint,
      filled: true,
      filledColor: AppColors.white,
      hintStyle: const TextStyle(
        color: AppColors.grey,
      ),
      initialValue: challengeTitle.value,
      onChanged: (newTitle) => _debouncer.run(
        () => context.read<CreateChallengeCubit>().onTitleChanged(newTitle),
      ),
    );
  }
}
