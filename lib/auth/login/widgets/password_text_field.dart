import 'package:app_ui/app_ui.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool showPassword = true;

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

  void toggleShowPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      key: const ValueKey('loginPasswordTextField'),
      textController: _controller,
      focusNode: _focusNode,
      floatingLabelBehaviour: FloatingLabelBehavior.always,
      cursorColor: context.reversedAdaptiveColor,
      style: ContentTextStyle.bodyText1.copyWith(
        color: context.reversedAdaptiveColor,
      ),
      hintText: context.l10n.passwordTextFieldHint,
      hintStyle: ContentTextStyle.bodyText2.copyWith(
        color: context.reversedAdaptiveColor,
      ),
      labelText: '${context.l10n.passwordTextFieldLabel} *',
      autofillHints: const [AutofillHints.email],
      labelStyle: ContentTextStyle.bodyText1.copyWith(
        color: context.reversedAdaptiveColor,
      ),
      obscureText: !showPassword,
      textInputType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      suffixIcon: Tappable.faded(
        backgroundColor: AppColors.transparent,
        onTap: toggleShowPassword,
        child: Icon(
          !showPassword ? Icons.visibility : Icons.visibility_off,
          color: context.reversedAdaptiveColor,
        ),
      ),
    );
  }
}
