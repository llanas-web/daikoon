import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/create/create_challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChoiceFormField extends StatefulWidget {
  const ChoiceFormField({super.key});

  @override
  State<ChoiceFormField> createState() => _ChoiceFormFieldState();
}

class _ChoiceFormFieldState extends State<ChoiceFormField> {
  late final TextEditingController _optionController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _optionController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _optionController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void addChoice() {
      context.read<PronosticStepCubit>().onChoicesAdded(
            _optionController.text,
          );
      _optionController.clear();
      _focusNode.requestFocus();
    }

    return Row(
      children: [
        Expanded(
          child: AppTextField(
            contentPadding: const EdgeInsets.symmetric(
              vertical: AppSpacing.lg,
              horizontal: AppSpacing.xlg,
            ),
            hintText: context.l10n.challengeCreationOptionsFormFieldHint,
            filled: true,
            filledColor: AppColors.white,
            hintStyle: UITextStyle.hintText,
            focusNode: _focusNode,
            textController: _optionController,
            onChanged: (value) {
              context.read<PronosticStepCubit>().onChoicesInputChanged(value);
            },
            suffixIcon: Padding(
              padding: const EdgeInsets.only(
                right: AppSpacing.xlg,
              ),
              child: Tappable(
                onTap: addChoice,
                child: const Icon(Icons.add),
              ),
            ),
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => addChoice(),
          ),
        ),
      ],
    );
  }
}
