import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/create/bloc/create_challenge_bloc.dart';
import 'package:daikoon/challenge/create/widgets/widgets.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class ChallengeQuestionForm extends StatefulWidget {
  const ChallengeQuestionForm({super.key});

  @override
  State<ChallengeQuestionForm> createState() => _ChallengeQuestionFormState();
}

class _ChallengeQuestionFormState extends State<ChallengeQuestionForm> {
  late final TextEditingController _questionController;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          context.l10n.challengeCreationQuestionFormLabel,
          style: context.headlineMedium,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${context.l10n.challengeCreationQuestionFormFieldLabel} :'),
            AppTextField(
              contentPadding: const EdgeInsets.symmetric(
                vertical: AppSpacing.lg,
                horizontal: AppSpacing.xlg,
              ),
              hintText: context.l10n.challengeCreationQuestionFormFieldHint,
              textController: _questionController,
              filled: true,
              filledColor: AppColors.white,
              hintStyle: const TextStyle(
                color: AppColors.grey,
              ),
              maxLines: 3,
              minLines: 1,
            ),
          ].spacerBetween(height: AppSpacing.md),
        ),
        ChallengeNextButton(
          onPressed: () {
            context.read<CreateChallengeBloc>().add(
                  CreateChallengeTitleContinued(
                    title: _questionController.text,
                  ),
                );
          },
        ),
        Tappable(
          child: Text(
            '< ${context.l10n.challengeCreationCancelButtonLabel}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              decoration: TextDecoration.underline,
              color: AppColors.primary,
            ),
          ),
        ),
      ].spacerBetween(height: AppSpacing.xxlg),
    );
  }
}
