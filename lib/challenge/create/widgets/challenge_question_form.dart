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
  late final TextEditingController _optionController;

  final List<String> _options = [];

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController();
    _optionController = TextEditingController();
  }

  void _addOption() {
    if (_optionController.text.isNotEmpty) {
      setState(() {
        _options.add(_optionController.text);
        _optionController.clear();
      });
    }
  }

  void _removeOption(int index) {
    setState(() {
      _options.removeAt(index);
    });
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${context.l10n.challengeCreationOptionFormLabel} :'),
            if (_options.isNotEmpty)
              Column(
                children: _options
                    .map((option) {
                      final index = _options.indexOf(option);
                      return _OptionItem(
                        option: option,
                        onRemove: () => _removeOption(index),
                      );
                    })
                    .toList()
                    .spacerBetween(height: AppSpacing.md),
              ),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.lg,
                      horizontal: AppSpacing.xlg,
                    ),
                    hintText: context.l10n.challengeCreationOptionFormFieldHing,
                    textController: _optionController,
                    filled: true,
                    filledColor: AppColors.white,
                    hintStyle: const TextStyle(
                      color: AppColors.grey,
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(
                        right: AppSpacing.xlg,
                      ),
                      child: Tappable(
                        onTap: _addOption,
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ),
                ),
              ],
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

class _OptionItem extends StatelessWidget {
  const _OptionItem({
    required this.option,
    required this.onRemove,
  });

  final String option;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              color: AppColors.white,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.lg,
              horizontal: AppSpacing.xlg,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(option, style: context.bodyLarge),
                Tappable(
                  onTap: onRemove,
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
