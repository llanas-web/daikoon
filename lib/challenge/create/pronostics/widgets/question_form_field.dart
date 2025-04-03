import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

typedef QuestionChangedCallback = void Function(String question);

class QuestionFormField extends StatefulWidget {
  const QuestionFormField({
    super.key,
  });

  @override
  State<QuestionFormField> createState() => _QuestionFormFieldState();
}

class _QuestionFormFieldState extends State<QuestionFormField> {
  late Debouncer _debouncer;
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer();
    _controller = TextEditingController(
        text: context.read<CreateChallengeCubit>().state.question);
    _focusNode = FocusNode();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode
      ..removeListener(_focusNodeListener)
      ..dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _focusNodeListener() {
    if (!_focusNode.hasFocus) {
      context.read<PronosticStepCubit>().onQuestionUnfocused();
    }
  }

  @override
  Widget build(BuildContext context) {
    final challengeQuestion = context.select(
      (PronosticStepCubit cubit) => cubit.state.challengeQuestion,
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
                hintText: context.l10n.challengeCreationQuestionFormFieldHint,
                filled: true,
                filledColor: AppColors.white,
                border: (challengeQuestion.errorMessage != null)
                    ? const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.red,
                        ),
                      )
                    : null,
                hintStyle: UITextStyle.hintText,
                textController: _controller,
                focusNode: _focusNode,
                onChanged: (newQuestion) => _debouncer.run(
                  () => context
                      .read<PronosticStepCubit>()
                      .onQuestionChanged(newQuestion),
                ),
                onTapOutside: (_) {
                  _focusNode.unfocus();
                  context.read<PronosticStepCubit>().onQuestionUnfocused();
                },
                errorText: challengeQuestion.errorMessage,
                errorMaxLines: 2,
                textInputAction: TextInputAction.next,
              ),
            ].spacerBetween(height: AppSpacing.md),
          ),
        ),
      ],
    );
  }
}
