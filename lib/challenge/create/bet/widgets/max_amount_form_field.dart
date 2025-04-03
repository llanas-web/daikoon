import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/create/bet/cubit/bet_step_cubit.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaxAmountFormField extends StatefulWidget {
  const MaxAmountFormField({required this.onSubmit, super.key});

  final VoidCallback onSubmit;

  @override
  State<MaxAmountFormField> createState() => _MaxAmountFormFieldState();
}

class _MaxAmountFormFieldState extends State<MaxAmountFormField> {
  late final FocusNode _focusNode;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = TextEditingController(
      text: context.read<BetStepCubit>().state.maxAmount?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppTextField(
        contentPadding: const EdgeInsets.symmetric(
          vertical: AppSpacing.lg,
          horizontal: AppSpacing.xlg,
        ),
        hintText: context.l10n.challengeCreationBetAmountMaxFormFieldLabel,
        filled: true,
        filledColor: AppColors.white,
        hintStyle: UITextStyle.hintText,
        textInputType: TextInputType.number,
        textInputAction: TextInputAction.done,
        textController: _controller,
        onFieldSubmitted: (_) => widget.onSubmit(),
        focusNode: _focusNode,
        onChanged: (newMinValue) {
          final minValue = int.tryParse(newMinValue);
          if (minValue != null) {
            context.read<BetStepCubit>().onMaxAmountChanged(minValue);
          }
        },
      ),
    );
  }
}
