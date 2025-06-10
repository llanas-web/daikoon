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
  late TextEditingController _betAmountController;
  late FocusNode _betAmountFocusNode;
  String? _choiceId;
  bool _hasBet = false;

  @override
  void initState() {
    super.initState();
    _betAmountController = TextEditingController();
    _betAmountFocusNode = FocusNode();
    final challengeState = context.read<ChallengeDetailsCubit>();
    final minBetValue = challengeState.state.challenge?.minBet;
    final userBet = challengeState.userBet;
    _choiceId = userBet?.choiceId;
    _betAmountController = TextEditingController(
      text: userBet?.amount.toString() ?? minBetValue?.toString(),
    );
    _hasBet = userBet?.amount != 0 || false;
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
      final minAmount = challenge.minBet;
      final maxAmount = challenge.maxBet;
      final amount = int.parse(_betAmountController.text);
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
        _betAmountFocusNode.requestFocus();
        return;
      }
      final userWallet = context.read<AppBloc>().state.userWalletAmount;
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
      if (amount < minAmount!) {
        snackBarError = SnackbarMessage.error(
          title: context.l10n.challengeDetailsAcceptedDaikoinsAmountErrorMinBet,
          description: context.l10n
              .challengeDetailsAcceptedDaikoinsAmountErrorBetMinDescription(
            '$minAmount',
          ),
          icon: Icons.error_outline_rounded,
        );
      }

      if (amount > maxAmount!) {
        snackBarError = SnackbarMessage.error(
          title: context.l10n.challengeDetailsAcceptedDaikoinsAmountErrorMaxBet,
          description: context.l10n
              .challengeDetailsAcceptedDaikoinsAmountErrorBetMaxDescription(
            '$maxAmount',
          ),
          icon: Icons.error_outline_rounded,
        );
      }
      if (snackBarError != null) {
        openSnackbar(snackBarError);
        _betAmountFocusNode.requestFocus();
        return;
      }

      return context.read<ChallengeDetailsCubit>().upsertBet(
            choiceId: _choiceId!,
            amount: _hasBet ? amount : 0,
          );
    }

    return Column(
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
            children: [
              Text(
                context.l10n.challengeDetailsAcceptedDaikoinsLabel,
                style: UITextStyle.subtitleBold,
              ),
              Column(
                children: [
                  DaikoonFormRadioItem(
                    title: 'bet',
                    isSelected: _hasBet,
                    onTap: () {
                      _betAmountFocusNode.requestFocus();
                      setState(
                        () => _hasBet = true,
                      );
                    },
                    child: TextField(
                      controller: _betAmountController,
                      onTapOutside: (_) => _betAmountFocusNode.unfocus(),
                      focusNode: _betAmountFocusNode,
                      onTap: () => setState(() => _hasBet = true),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  DaikoonFormRadioItem(
                    title:
                        context.l10n.challengeDetailsAcceptedDaikoinsNoBetLabel,
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
        const Gap.v(
          AppSpacing.xlg,
        ),
      ].spacerBetween(height: AppSpacing.xlg),
    );
  }
}
