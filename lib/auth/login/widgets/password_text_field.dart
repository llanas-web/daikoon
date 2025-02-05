import 'package:app_ui/app_ui.dart';
import 'package:daikoon/auth/login/cubit/login_cubit.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
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
      context.read<LoginCubit>().onPasswordUnfocused();
    }
  }

  @override
  Widget build(BuildContext context) {
    final passwordError =
        context.select((LoginCubit cubit) => cubit.state.password.errorMessage);

    final showPassword =
        context.select((LoginCubit cubit) => cubit.state.showPassword);

    return AppTextField(
      key: const ValueKey('loginPasswordTextField'),
      textController: _controller,
      errorText: passwordError,
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
        onTap: context.read<LoginCubit>().changePasswordVisibility,
        child: Icon(
          !showPassword ? Icons.visibility : Icons.visibility_off,
          color: context.reversedAdaptiveColor,
        ),
      ),
    );
  }
}
