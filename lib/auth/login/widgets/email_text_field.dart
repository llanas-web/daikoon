import 'package:app_ui/app_ui.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';

class EmailFormField extends StatefulWidget {
  const EmailFormField({super.key});

  @override
  State<EmailFormField> createState() => _EmailFormFieldState();
}

class _EmailFormFieldState extends State<EmailFormField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      key: const ValueKey('loginEmailTextField'),
      textController: _controller,
      focusNode: _focusNode,
      floatingLabelBehaviour: FloatingLabelBehavior.always,
      textInputAction: TextInputAction.next,
      textInputType: TextInputType.emailAddress,
      cursorColor: context.reversedAdaptiveColor,
      style: ContentTextStyle.bodyText1.copyWith(
        color: context.reversedAdaptiveColor,
      ),
      hintText: context.l10n.emailTextFieldHint,
      hintStyle: ContentTextStyle.bodyText2.copyWith(
        color: context.reversedAdaptiveColor,
      ),
      labelText: '${context.l10n.emailTextFieldLabel} *',
      autofillHints: const [AutofillHints.email],
      labelStyle: ContentTextStyle.bodyText1.copyWith(
        color: context.reversedAdaptiveColor,
      ),
    );
  }
}
