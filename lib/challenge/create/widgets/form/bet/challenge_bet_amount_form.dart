import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:daikoon_blocks_ui/daikoon_blocks_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class ChallengeBetAmountForm extends StatefulWidget {
  const ChallengeBetAmountForm({super.key});

  @override
  State<ChallengeBetAmountForm> createState() => _ChallengeBetAmountFormState();
}

class _ChallengeBetAmountFormState extends State<ChallengeBetAmountForm> {
  late final FocusNode _minAmountFocusNode;
  late final FocusNode _maxAmountFocusNode;
  late final TextEditingController _minAmountController;
  late final TextEditingController _maxAmountController;

  @override
  void initState() {
    super.initState();
    _minAmountFocusNode = FocusNode();
    _maxAmountFocusNode = FocusNode();
    _minAmountController = TextEditingController();
    _maxAmountController = TextEditingController();
    _minAmountFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _minAmountFocusNode.dispose();
    _maxAmountFocusNode.dispose();
    _minAmountController.dispose();
    _maxAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _minAmountController.text = context.select(
      (CreateChallengeCubit cubit) => cubit.state.minAmount.toString(),
    );
    _maxAmountController.text = context.select(
      (CreateChallengeCubit cubit) => cubit.state.maxAmount.toString(),
    );
    return Column(
      children: [
        Text(
          context.l10n.challengeCreationBetFormLabel,
          style: context.headlineMedium,
        ),
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.lg,
                      horizontal: AppSpacing.xlg,
                    ),
                    hintText: context
                        .l10n.challengeCreationBetAmountMinFormFieldLabel,
                    filled: true,
                    filledColor: AppColors.white,
                    hintStyle: const TextStyle(
                      color: AppColors.grey,
                    ),
                    textInputType: TextInputType.number,
                    focusNode: _minAmountFocusNode,
                    textInputAction: TextInputAction.next,
                    textController: _minAmountController,
                    onChanged: (newMinValue) {
                      final minValue = int.tryParse(newMinValue);
                      if (minValue != null) {
                        context
                            .read<CreateChallengeCubit>()
                            .onMinAmountChanged(minValue);
                      }
                    },
                  ),
                ),
                const Gap.h(AppSpacing.xlg),
                Expanded(
                  child: AppTextField(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.lg,
                      horizontal: AppSpacing.xlg,
                    ),
                    hintText: context
                        .l10n.challengeCreationBetAmountMaxFormFieldLabel,
                    filled: true,
                    filledColor: AppColors.white,
                    hintStyle: const TextStyle(
                      color: AppColors.grey,
                    ),
                    textInputType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    textController: _maxAmountController,
                    onFieldSubmitted: (_) =>
                        context.read<FormStepperCubit>().nextStep(),
                    focusNode: _maxAmountFocusNode,
                    onChanged: (newMinValue) {
                      final minValue = int.tryParse(newMinValue);
                      if (minValue != null) {
                        context
                            .read<CreateChallengeCubit>()
                            .onMaxAmountChanged(minValue);
                      }
                    },
                  ),
                ),
              ],
            ),
            const Gap.v(AppSpacing.md),
            DaikoonFormRadioItem(
              title:
                  context.l10n.challengeCreationBetAmountNoLimitFormFieldLabel,
              onTap: () {
                _minAmountFocusNode.unfocus();
                _maxAmountFocusNode.unfocus();
                context.read<CreateChallengeCubit>().onNoBetAmount();
              },
              isSelected: context.select(
                (CreateChallengeCubit cubit) => cubit.state.noBetAmount,
              ),
            ),
          ],
        ),
      ].spacerBetween(height: AppSpacing.xxlg),
    );
  }
}
