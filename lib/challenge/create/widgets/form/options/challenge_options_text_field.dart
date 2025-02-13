import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/create/create_challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChallengeOptionsTextField extends StatefulWidget {
  const ChallengeOptionsTextField({super.key});

  @override
  State<ChallengeOptionsTextField> createState() =>
      _ChallengeOptionsTextFieldState();
}

class _ChallengeOptionsTextFieldState extends State<ChallengeOptionsTextField> {
  late final TextEditingController _optionController;

  @override
  void initState() {
    super.initState();
    _optionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      contentPadding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.xlg,
      ),
      hintText: context.l10n.challengeCreationOptionsFormFieldHint,
      filled: true,
      filledColor: AppColors.white,
      hintStyle: const TextStyle(
        color: AppColors.grey,
      ),
      textController: _optionController,
      suffixIcon: Padding(
        padding: const EdgeInsets.only(
          right: AppSpacing.xlg,
        ),
        child: Tappable(
          onTap: () {
            context.read<CreateChallengeCubit>().onOptionAdded(
                  _optionController.text,
                );
            _optionController.clear();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
