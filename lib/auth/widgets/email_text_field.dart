import 'package:app_ui/app_ui.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

typedef EmailChangedCallback<T> = void Function(T cubit, String email);
typedef EmailUnfocusedCallback<T> = void Function(T cubit);

class EmailFormField<T extends Cubit<S>, S> extends StatefulWidget {
  const EmailFormField({
    required this.onEmailChanged,
    required this.onEmailUnfocused,
    required this.emailError,
    required this.isLoading,
    super.key,
  });

  final EmailChangedCallback<T> onEmailChanged;
  final EmailUnfocusedCallback<T> onEmailUnfocused;
  final String? emailError;
  final bool isLoading;

  @override
  State<EmailFormField<T, S>> createState() => _EmailFormFieldState<T, S>();
}

class _EmailFormFieldState<T extends Cubit<S>, S>
    extends State<EmailFormField<T, S>> {
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
      widget.onEmailUnfocused(cubit);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<T>();

    return AppTextField(
      key: const ValueKey('loginEmailTextField'),
      textController: _controller,
      onChanged: (value) => _debouncer.run(() {
        widget.onEmailChanged(cubit, value);
      }),
      focusNode: _focusNode,
      floatingLabelBehaviour: FloatingLabelBehavior.always,
      textInputAction: TextInputAction.next,
      textInputType: TextInputType.emailAddress,
      textCapitalization: TextCapitalization.none,
      cursorColor: context.reversedAdaptiveColor,
      style: ContentTextStyle.bodyText1.copyWith(
        color: context.reversedAdaptiveColor,
      ),
      enabled: !widget.isLoading,
      hintText: context.l10n.emailTextFieldHint,
      hintStyle: ContentTextStyle.bodyText2.copyWith(
        color: context.reversedAdaptiveColor,
      ),
      labelText: '${context.l10n.emailTextFieldLabel} *',
      autofillHints: const [AutofillHints.email],
      labelStyle: ContentTextStyle.bodyText1.copyWith(
        color: context.reversedAdaptiveColor,
      ),
      errorText: widget.emailError,
    );
  }
}
