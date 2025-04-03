import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class ChallengeTitleFormField extends StatefulWidget {
  const ChallengeTitleFormField({super.key});

  @override
  State<ChallengeTitleFormField> createState() =>
      _ChallengeTitleFormFieldState();
}

class _ChallengeTitleFormFieldState extends State<ChallengeTitleFormField> {
  late Debouncer _debouncer;
  late FocusNode _focusNode;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer();
    _focusNode = FocusNode()..addListener(_focusNodeListener);
    _controller = TextEditingController(
      text: context.read<CreateChallengeCubit>().state.challengeTitle.value,
    );
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _focusNode
      ..removeListener(_focusNodeListener)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  void _focusNodeListener() {
    if (!_focusNode.hasFocus) {
      context.read<CreateChallengeCubit>().onTitleUnfocused();
    }
  }

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
      border: (challengeTitle.errorMessage != null)
          ? const OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.red,
              ),
            )
          : null,
      hintStyle: UITextStyle.hintText,
      onChanged: (newTitle) => _debouncer.run(
        () => context.read<CreateChallengeCubit>().onTitleChanged(newTitle),
      ),
      onTapOutside: (_) {
        _focusNode.unfocus();
        context.read<CreateChallengeCubit>().onTitleUnfocused();
      },
      focusNode: _focusNode,
      textController: _controller,
      floatingLabelBehaviour: FloatingLabelBehavior.always,
      errorText: challengeTitle.errorMessage,
      errorMaxLines: 2,
      onFieldSubmitted: (_) {
        final formIndex = context.read<FormStepperCubit>().state;
        if (context
            .read<CreateChallengeCubit>()
            .isCurrentFormValid(formIndex)) {
          context.read<FormStepperCubit>().nextStep();
        }
      },
    );
  }
}
