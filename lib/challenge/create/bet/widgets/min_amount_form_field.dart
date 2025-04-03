import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/challenge/create/bet/cubit/bet_step_cubit.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MinAmountFormField extends StatefulWidget {
  const MinAmountFormField({super.key});

  @override
  State<MinAmountFormField> createState() => _MinAmountFormFieldState();
}

class _MinAmountFormFieldState extends State<MinAmountFormField> {
  late final FocusNode _focusNode;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = TextEditingController(
      text: context.read<CreateChallengeCubit>().state.minAmount?.toString() ??
          '',
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
        hintText: context.l10n.challengeCreationBetAmountMinFormFieldLabel,
        filled: true,
        filledColor: AppColors.white,
        hintStyle: UITextStyle.hintText,
        textInputType: TextInputType.number,
        focusNode: _focusNode,
        textInputAction: TextInputAction.next,
        textController: _controller,
        onChanged: (newMinValue) {
          final minValue = int.tryParse(newMinValue);
          if (minValue != null) {
            context.read<BetStepCubit>().onMinAmountChanged(minValue);
          }
        },
      ),
    );
  }
}
