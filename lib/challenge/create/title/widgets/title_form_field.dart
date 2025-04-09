import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class TitleFormField extends StatefulWidget {
  const TitleFormField({required this.onSubmit, super.key});

  final void Function() onSubmit;

  @override
  State<TitleFormField> createState() => _TitleFormFieldState();
}

class _TitleFormFieldState extends State<TitleFormField> {
  late Debouncer _debouncer;
  late FocusNode _focusNode;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer();
    _focusNode = FocusNode()..addListener(_focusNodeListener);
    _controller = TextEditingController(
      text: context.read<TitleStepCubit>().state.challengeTitle.value,
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
      context.read<TitleStepCubit>().onTitleUnfocused();
    }
  }

  @override
  Widget build(BuildContext context) {
    final challengeTitle = context.select(
      (TitleStepCubit cubit) => cubit.state.challengeTitle,
    );

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${context.l10n.challengeCreationQuestionFormFieldLabel} :',
                style: UITextStyle.subtitle,
              ),
              AppTextField(
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
                  () => context.read<TitleStepCubit>().onTitleChanged(newTitle),
                ),
                onTapOutside: (_) {
                  _focusNode.unfocus();
                  context.read<TitleStepCubit>().onTitleUnfocused();
                },
                focusNode: _focusNode,
                textController: _controller,
                floatingLabelBehaviour: FloatingLabelBehavior.always,
                errorText: challengeTitle.errorMessage,
                errorMaxLines: 2,
                onFieldSubmitted: (_) => widget.onSubmit(),
              ),
            ].spacerBetween(height: AppSpacing.md),
          ),
        ),
      ],
    );
  }
}
