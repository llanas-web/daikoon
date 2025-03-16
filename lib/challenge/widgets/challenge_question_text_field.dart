import 'package:app_ui/app_ui.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

typedef ChallengeQuestionChangedCallback = void Function(String question);

class ChallengeQuestionTextField extends StatefulWidget {
  const ChallengeQuestionTextField({
    required this.initialValue,
    this.onQuestionChanged,
    this.readOnly = false,
    super.key,
  });

  final String initialValue;
  final bool readOnly;
  final ChallengeQuestionChangedCallback? onQuestionChanged;

  @override
  State<ChallengeQuestionTextField> createState() =>
      _ChallengeQuestionTextFieldState();
}

class _ChallengeQuestionTextFieldState
    extends State<ChallengeQuestionTextField> {
  late Debouncer _debouncer;
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      contentPadding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.xlg,
      ),
      hintText: context.l10n.challengeCreationQuestionFormFieldHint,
      filled: true,
      filledColor: AppColors.white,
      hintStyle: UITextStyle.hintText,
      textController: _controller,
      focusNode: _focusNode,
      readOnly: widget.readOnly,
      onChanged: widget.onQuestionChanged != null
          ? (newQuestion) => _debouncer.run(
                () => widget.onQuestionChanged!(newQuestion),
              )
          : null,
      textInputAction: TextInputAction.next,
    );
  }
}
