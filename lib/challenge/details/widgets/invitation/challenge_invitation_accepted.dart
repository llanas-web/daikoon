import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/app.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:daikoon_blocks_ui/daikoon_blocks_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class ChallengeInvitationAccepted extends StatefulWidget {
  const ChallengeInvitationAccepted({super.key});

  @override
  State<ChallengeInvitationAccepted> createState() =>
      __ChallengeInvitationAcceptedState();
}

class __ChallengeInvitationAcceptedState
    extends State<ChallengeInvitationAccepted> {
  String? _choiceId;
  bool _hasBet = false;
  double minValue = 0;
  double maxValue = 0;
  TextEditingController? _betAmountController;
  FocusNode? _betAmountFocusNode;
  late double userWallet;

  var _betAmountSliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    userWallet = context.read<AppBloc>().state.userWalletAmount.toDouble();
    final challengeState = context.read<ChallengeDetailsCubit>();
    minValue = challengeState.state.challenge!.minBet?.toDouble() ?? 0.0;
    maxValue = challengeState.state.challenge!.maxBet?.toDouble() ?? userWallet;
    final userBet = challengeState.userBet;
    _choiceId = userBet?.choiceId;
    _hasBet = userBet?.amount != 0 || false;
    _betAmountSliderValue = minValue;
    _betAmountController = TextEditingController(
      text: _betAmountSliderValue.round().toString(),
    );
    _betAmountFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final challenge = context.select(
      (ChallengeDetailsCubit cubit) => cubit.state.challenge,
    )!;
    final userBet = context.select(
      (ChallengeDetailsCubit cubit) => cubit.userBet,
    );

    Future<void> upsertBet() async {
      final amount = _betAmountSliderValue.round();
      SnackbarMessage? snackBarError;
      if (!_hasBet) {
        return context.read<ChallengeDetailsCubit>().upsertBet(
              choiceId: _choiceId!,
              amount: 0,
            );
      }
      if (_choiceId == null) {
        snackBarError = SnackbarMessage.error(
          title: context.l10n.challengeDetailsAcceptedNoChoiceError,
          icon: Icons.error_outline_rounded,
        );
        openSnackbar(snackBarError);
        return;
      }
      if (amount > userWallet) {
        snackBarError = SnackbarMessage.error(
          title: context.l10n.challengeDetailsAcceptedDaikoinsAmountErrorWallet,
          description: context.l10n
              .challengeDetailsAcceptedDaikoinsAmountErrorWalletDescription(
            '$userWallet',
          ),
          icon: Icons.error_outline_rounded,
        );
      }
      if (snackBarError != null) {
        openSnackbar(snackBarError);
        return;
      }

      return context.read<ChallengeDetailsCubit>().upsertBet(
            choiceId: _choiceId!,
            amount: _hasBet ? amount : 0,
          );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.l10n.challengeDetailsAcceptedCreatorTitle(
            challenge.creator!.displayUsername,
          ),
          style: UITextStyle.titleSmallBold.copyWith(
            fontWeight: AppFontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          width: 300,
          child: Text(
            context.l10n.challengeDetailsInvitationTitle(challenge.title!),
            style: UITextStyle.title,
            textAlign: TextAlign.center,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.challengeDetailsQuestionLabel,
              style: UITextStyle.subtitleBold,
            ),
            ChallengeQuestionTextField(
              initialValue: challenge.question!,
              readOnly: true,
            ),
          ].spacerBetween(height: AppSpacing.md),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.challengeDetailsAcceptedChoiceLabel,
              style: UITextStyle.subtitleBold,
            ),
            if (challenge.choices.isNotEmpty)
              Column(
                children: challenge.choices
                    .map((choice) {
                      return DaikoonFormRadioItem(
                        title: choice.value,
                        isSelected: choice.id == _choiceId,
                        onTap: () => setState(() => _choiceId = choice.id),
                      );
                    })
                    .toList()
                    .spacerBetween(height: AppSpacing.md),
              ),
          ].spacerBetween(height: AppSpacing.md),
        ),
        if (challenge.hasBet)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.challengeDetailsAcceptedDaikoinsLabel,
                style: UITextStyle.subtitleBold,
              ),
              Column(
                children: [
                  const Gap.v(AppSpacing.md),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppTextField(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.lg,
                          horizontal: AppSpacing.xlg,
                        ),
                        filled: true,
                        filledColor: AppColors.white,
                        hintStyle: UITextStyle.hintText,
                        textController: _betAmountController,
                        focusNode: _betAmountFocusNode,
                        suffixText: 'Daïkoins',
                        textInputType: TextInputType.number,
                        onTapOutside: (value) {
                          if (_betAmountController!.text.isEmpty) {
                            _betAmountController?.text =
                                minValue.round().toString();
                          }
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        onChanged: (value) => setState(
                          () {
                            final parsedValue = int.tryParse(value) ?? 0;
                            if (parsedValue < minValue) {
                              _betAmountController?.text =
                                  minValue.round().toString();
                            } else if (parsedValue > maxValue) {
                              _betAmountController?.text =
                                  maxValue.round().toString();
                            } else {
                              _betAmountSliderValue = parsedValue.toDouble();
                            }
                          },
                        ),
                      ),
                      Slider(
                        value: _betAmountSliderValue,
                        min: minValue,
                        max: maxValue,
                        divisions: 100,
                        activeColor: AppColors.secondary,
                        onChanged: (double value) {
                          setState(() {
                            _betAmountSliderValue = value;
                            _betAmountController?.text =
                                value.round().toString();
                          });
                        },
                      ),
                    ],
                  ),
                  if (challenge.minBet != null && challenge.minBet == 0)
                    DaikoonFormRadioItem(
                      title: context
                          .l10n.challengeDetailsAcceptedDaikoinsNoBetLabel,
                      isSelected: !_hasBet,
                      onTap: () => setState(
                        () => _hasBet = false,
                      ),
                    ),
                ].spacerBetween(height: AppSpacing.md),
              ),
            ].spacerBetween(height: AppSpacing.md),
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.challengeDetailsLimitDateLabel,
              style: UITextStyle.subtitleBold,
            ),
            Row(
              children: [
                Expanded(
                  child: DaikoonFormDateSelector(
                    value: challenge.limitDate,
                    readOnly: true,
                  ),
                ),
                Expanded(
                  child: DaikoonFormTimeSelector(
                    value: challenge.limitDate,
                    readOnly: true,
                  ),
                ),
              ].spacerBetween(width: AppSpacing.md),
            ),
          ].spacerBetween(height: AppSpacing.md),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.challengeDetailsStartDateLabel,
              style: UITextStyle.subtitleBold,
            ),
            Row(
              children: [
                Expanded(
                  child: DaikoonFormDateSelector(
                    value: challenge.starting,
                    readOnly: true,
                  ),
                ),
                Expanded(
                  child: DaikoonFormTimeSelector(
                    value: challenge.starting,
                    readOnly: true,
                  ),
                ),
              ].spacerBetween(width: AppSpacing.md),
            ),
          ].spacerBetween(height: AppSpacing.md),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.challengeDetailsEndDateLabel,
              style: UITextStyle.subtitleBold,
            ),
            Row(
              children: [
                Expanded(
                  child: DaikoonFormDateSelector(
                    value: challenge.ending,
                    readOnly: true,
                  ),
                ),
                Expanded(
                  child: DaikoonFormTimeSelector(
                    value: challenge.ending,
                    readOnly: true,
                  ),
                ),
              ].spacerBetween(width: AppSpacing.md),
            ),
          ].spacerBetween(height: AppSpacing.md),
        ),
        Row(
          children: [
            Expanded(
              child: AppButton(
                text: context.l10n.challengeDetailsAcceptedValidateButtonLabel,
                onPressed: upsertBet,
                color: AppColors.secondary,
                textStyle: UITextStyle.button.copyWith(
                  color: context.reversedAdaptiveColor,
                ),
                loading: userBet != null,
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(AppColors.secondary),
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(
                      vertical: AppSpacing.lg,
                      horizontal: AppSpacing.xxlg,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ].spacerBetween(height: AppSpacing.xlg),
    );
  }
}
