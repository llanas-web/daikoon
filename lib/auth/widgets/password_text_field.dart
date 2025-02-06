import 'package:app_ui/app_ui.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

typedef PasswordChangedCallback<T> = void Function(T cubit, String email);
typedef PasswordUnfocusedCallback<T> = void Function(T cubit);
typedef PasswordToggleVisibilityCallback<T> = void Function(T cubit);

class PasswordTextField<T extends Cubit<S>, S> extends StatefulWidget {
  const PasswordTextField({
    required this.onPasswordChanged,
    required this.onPasswordUnfocused,
    required this.onChangePasswordVisibility,
    required this.passwordError,
    required this.showPassword,
    required this.isLoading,
    super.key,
  });

  final PasswordChangedCallback<T> onPasswordChanged;
  final PasswordUnfocusedCallback<T> onPasswordUnfocused;
  final PasswordToggleVisibilityCallback<T> onChangePasswordVisibility;
  final String? passwordError;
  final bool showPassword;
  final bool isLoading;

  @override
  State<PasswordTextField<T, S>> createState() =>
      _PasswordTextFieldState<T, S>();
}

class _PasswordTextFieldState<T extends Cubit<S>, S>
    extends State<PasswordTextField<T, S>> {
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
      final cubit = context.read<T>();
      widget.onPasswordUnfocused(cubit);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<T>();

    return AppTextField(
      key: const ValueKey('loginPasswordTextField'),
      textController: _controller,
      onChanged: (value) => _debouncer.run(
        () => widget.onPasswordChanged(cubit, value),
      ),
      errorText: widget.passwordError,
      focusNode: _focusNode,
      floatingLabelBehaviour: FloatingLabelBehavior.always,
      cursorColor: context.reversedAdaptiveColor,
      style: ContentTextStyle.bodyText1.copyWith(
        color: context.reversedAdaptiveColor,
      ),
      enabled: !widget.isLoading,
      hintText: context.l10n.passwordTextFieldHint,
      hintStyle: ContentTextStyle.bodyText2.copyWith(
        color: context.reversedAdaptiveColor,
      ),
      labelText: '${context.l10n.passwordTextFieldLabel} *',
      autofillHints: const [AutofillHints.email],
      labelStyle: ContentTextStyle.bodyText1.copyWith(
        color: context.reversedAdaptiveColor,
      ),
      obscureText: !widget.showPassword,
      textInputType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      suffixIcon: Tappable.faded(
        backgroundColor: AppColors.transparent,
        onTap: widget.isLoading
            ? null
            : () => widget.onChangePasswordVisibility(cubit),
        child: Icon(
          !widget.showPassword ? Icons.visibility : Icons.visibility_off,
          color: context.reversedAdaptiveColor,
        ),
      ),
    );
  }
}
