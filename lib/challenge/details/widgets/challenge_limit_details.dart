import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:daikoon_blocks_ui/daikoon_blocks_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class ChallengeLimitDetails extends StatelessWidget {
  const ChallengeLimitDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: GlobalKey<NavigatorState>(),
      onGenerateRoute: (settings) {
        final page = settings.name == '/finish'
            ? const ChallengeLimitDetailsForm()
            : const ChallengeLimitDetailsStats();
        return MaterialPageRoute(builder: (context) => page);
      },
    );
  }
}

class ChallengeLimitDetailsStats extends StatelessWidget {
  const ChallengeLimitDetailsStats({super.key});

  @override
  Widget build(BuildContext context) {
    final challengeDetailsCubit = context.read<ChallengeDetailsCubit>();
    final challenge = challengeDetailsCubit.state.challenge!;
    final choices = challengeDetailsCubit.state.challenge!.choices;
    final bets = challengeDetailsCubit.state.bets;

    return Column(
      children: [
        Column(
          children: [
            Text(
              context.l10n.challengeDetailsStatsCreatorTitle(
                challenge.creator!.displayUsername,
              ),
              style: UITextStyle.subtitle.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              width: 300,
              child: Text(
                context.l10n.challengeDetailsStatsTitle(challenge.title!),
                style: UITextStyle.title,
                textAlign: TextAlign.center,
              ),
            ),
          ].spacerBetween(height: AppSpacing.md),
        ),
        ...choices.map((choice) {
          final choiceBets = bets.where(
            (bet) => bet.choiceId == choice.id,
          );
          final participantUsernames = choiceBets
              .map((bet) => bet.userId)
              .map(
                (userId) => challenge.participants
                    .firstWhere((participant) => participant.id == userId)
                    .displayUsername,
              )
              .join(', ');
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    choice.value,
                    style: UITextStyle.titleSmallBold,
                  ),
                  Text(
                    '${choiceBets.length}',
                    style: UITextStyle.titleSmallBold.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
              LinearProgressIndicator(
                value: bets.isEmpty ? 0 : choiceBets.length / bets.length,
                minHeight: 18,
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(18),
                backgroundColor: AppColors.primary.withValues(alpha: 0.35),
              ),
              if (participantUsernames.isEmpty)
                Text(
                  'Pas de votant',
                  style: UITextStyle.bodyText,
                )
              else
                Text(
                  'Vote de : $participantUsernames',
                  style: UITextStyle.bodyText,
                ),
            ].spacerBetween(height: AppSpacing.sm),
          );
        }),
        if (challengeDetailsCubit.isOwner)
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: context.l10n.challengeDetailsStatsButtonLabel,
                  onPressed: () => Navigator.of(context).pushNamed('/finish'),
                  color: AppColors.secondary,
                  textStyle: UITextStyle.button.copyWith(
                    color: context.reversedAdaptiveColor,
                  ),
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
      ].spacerBetween(height: AppSpacing.xxxlg),
    );
  }
}

class ChallengeLimitDetailsForm extends StatefulWidget {
  const ChallengeLimitDetailsForm({super.key});

  @override
  State<ChallengeLimitDetailsForm> createState() =>
      _ChallengeLimitDetailsFormState();
}

class _ChallengeLimitDetailsFormState extends State<ChallengeLimitDetailsForm> {
  final ValueNotifier<String?> _choiceId = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    final challengeDetailsCubit = context.read<ChallengeDetailsCubit>();
    final challenge = challengeDetailsCubit.state.challenge!;
    final bets = challengeDetailsCubit.state.bets;

    Future<void> validateChoice() async {
      if (_choiceId.value == null) {
        return;
      }

      await challengeDetailsCubit.validateChoice(_choiceId.value!);
    }

    return AppConstrainedScrollView(
      child: Column(
        children: [
          Text(
            context.l10n.challengeDetailsStatsCreatorTitle(
              challenge.creator!.displayUsername,
            ),
            style: context.headlineSmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            width: 300,
            child: Text(
              context.l10n.challengeDetailsFinishTitle(challenge.title!),
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
          const Divider(color: AppColors.primary),
          ValueListenableBuilder<String?>(
            valueListenable: _choiceId,
            builder: (context, selectedChoiceId, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.challengeDetailsFinishChoiceLabel,
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
                              isSelected: choice.id == selectedChoiceId,
                              onTap: () => _choiceId.value = choice.id,
                            );
                          })
                          .toList()
                          .spacerBetween(height: AppSpacing.md),
                    ),
                ],
              );
            },
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'daikoins',
                style: TextStyle(
                  fontWeight: AppFontWeight.extraBold,
                ),
              ),
              Icon(
                Icons.check,
                color: AppColors.secondary,
              ),
            ],
          ),
          const Divider(color: AppColors.primary),
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
          const Divider(color: AppColors.primary),
          Column(
            children: [
              Text(
                context.l10n.challengeDetailsFinishWinnerLabel,
                style: const TextStyle(
                  fontWeight: AppFontWeight.extraBold,
                ),
              ),
              Container(
                width: 300,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.xxlg),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.xlg,
                  horizontal: AppSpacing.xlg,
                ),
                child: ValueListenableBuilder<String?>(
                  valueListenable: _choiceId,
                  builder: (context, choiceId, _) {
                    final choiceBets = bets.where(
                      (bet) => bet.choiceId == choiceId,
                    );
                    final participantUsernames = choiceBets
                        .map((bet) => bet.userId)
                        .map(
                          (userId) => challenge.participants
                              .firstWhere(
                                (participant) => participant.id == userId,
                              )
                              .displayUsername,
                        )
                        .toList();
                    return Text(
                      participantUsernames.join(', '),
                      style: context.headlineSmall?.copyWith(
                        fontWeight: AppFontWeight.extraBold,
                      ),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              ),
            ].spacerBetween(height: AppSpacing.md),
          ),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: context.l10n.challengeDetailsFinishButtonLabel,
                  onPressed: validateChoice,
                  color: AppColors.secondary,
                  textStyle: UITextStyle.button.copyWith(
                    color: context.reversedAdaptiveColor,
                  ),
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
