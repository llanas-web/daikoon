import 'package:app_ui/app_ui.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

typedef OtpChangedCallback<T> = void Function(T cubit, String email);
typedef OtpUnfocusedCallback<T> = void Function(T cubit);

class OtpFormField<T extends Cubit<S>, S> extends StatefulWidget {
  const OtpFormField({
    required this.onOtpChanged,
    required this.onOtpUnfocused,
    required this.otpError,
    required this.isLoading,
    super.key,
  });

  final OtpChangedCallback<T> onOtpChanged;
  final OtpUnfocusedCallback<T> onOtpUnfocused;
  final String? otpError;
  final bool isLoading;

  @override
  State<OtpFormField<T, S>> createState() => _OtpFormFieldState<T, S>();
}

class _OtpFormFieldState<T extends Cubit<S>, S>
    extends State<OtpFormField<T, S>> {
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
      widget.onOtpUnfocused(cubit);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<T>();

    return AppTextField(
      filled: true,
      focusNode: _focusNode,
      hintText: context.l10n.otpText,
      enabled: !widget.isLoading,
      textInputAction: TextInputAction.next,
      textInputType: TextInputType.number,
      autofillHints: const [AutofillHints.oneTimeCode],
      onChanged: (value) => _debouncer.run(
        () => widget.onOtpChanged(cubit, value),
      ),
      errorText: widget.otpError,
    );
  }
}
