import 'package:app_ui/app_ui.dart';
import 'package:daikoon/auth/login/cubit/login_cubit.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class EmailFormField extends StatefulWidget {
  const EmailFormField({super.key});

  @override
  State<EmailFormField> createState() => _EmailFormFieldState();
}

class _EmailFormFieldState extends State<EmailFormField> {
  late Debouncer _debouncer;
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer();
    _controller = TextEditingController();
    _focusNode = FocusNode()..addListener(_focusNodeListener);
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _controller.dispose();
    _focusNode
      ..removeListener(_focusNodeListener)
      ..dispose();
    super.dispose();
  }

  void _focusNodeListener() {
    if (!_focusNode.hasFocus) {
      context.read<LoginCubit>().onEmailUnfocused();
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailError =
        context.select((LoginCubit cubit) => cubit.state.email.errorMessage);

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
      onChanged: (value) => _debouncer.run(() {
        context.read<LoginCubit>().onEmailChanged(value);
      }),
      errorText: emailError,
    );
  }
}
