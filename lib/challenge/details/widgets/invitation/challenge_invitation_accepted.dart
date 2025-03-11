import 'package:app_ui/app_ui.dart';
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
  String? _choiceId;
  bool _hasBet = false;

  @override
  void initState() {
    super.initState();
    final challengeState = context.read<ChallengeDetailsCubit>();
    final minBetValue = challengeState.state.challenge?.minBet;
    final userBet = challengeState.userBet;
    _choiceId = userBet?.choiceId;
    _betAmountController = TextEditingController(
      text: userBet?.amount.toString() ?? minBetValue?.toString(),
    );
    _hasBet = userBet?.amount != 0 || false;
  }

  Future<void> createOrUpdateBet() {
    return context.read<ChallengeDetailsCubit>().createOrUpdateBet(
          choiceId: _choiceId!,
          amount: _hasBet ? int.parse(_betAmountController.text) : 0,
        );
  }

  @override
  Widget build(BuildContext context) {
    final challenge = context.select(
      (ChallengeDetailsCubit cubit) => cubit.state.challenge,
    )!;

    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            context.l10n.challengeDetailsAcceptedCreatorTitle(
              challenge.creator!.displayUsername,
            ),
            style: context.headlineSmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            width: 300,
            child: Text(
              context.l10n.challengeDetailsInvitationTitle(challenge.title!),
              style: context.headlineLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.challengeDetailsQuestionLabel,
                style: const TextStyle(
                  fontWeight: AppFontWeight.extraBold,
                ),
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
                style: const TextStyle(
                  fontWeight: AppFontWeight.extraBold,
                ),
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
            ],
          ),
          if (challenge.hasBet)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.challengeDetailsAcceptedDaikoinsLabel,
                  style: const TextStyle(
                    fontWeight: AppFontWeight.extraBold,
                  ),
                ),
                Column(
                  children: [
                    DaikoonFormRadioItem(
                      title: 'bet',
                      isSelected: _hasBet,
                      onTap: () => _betAmountController.text,
                      child: TextField(
                        controller: _betAmountController,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    DaikoonFormRadioItem(
                      title: 'bet',
                      isSelected: !_hasBet,
                      onTap: () => setState(
                        () => _hasBet = false,
                      ),
                    ),
                  ].spacerBetween(height: AppSpacing.md),
                ),
              ],
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.challengeDetailsLimitDateLabel,
                style: const TextStyle(
                  fontWeight: AppFontWeight.extraBold,
                ),
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
                style: const TextStyle(
                  fontWeight: AppFontWeight.extraBold,
                ),
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
                style: const TextStyle(
                  fontWeight: AppFontWeight.extraBold,
                ),
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
                  text:
                      context.l10n.challengeDetailsAcceptedValidateButtonLabel,
                  onPressed: createOrUpdateBet,
                  color: AppColors.secondary,
                  style: const ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(AppColors.secondary),
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
      ),
    );
  }
}
