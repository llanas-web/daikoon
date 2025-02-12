import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/create/bloc/create_challenge_bloc.dart';
import 'package:daikoon/challenge/create/widgets/widgets.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChallengeQuestionForm extends StatefulWidget {
  const ChallengeQuestionForm({super.key});

  @override
  State<ChallengeQuestionForm> createState() => _ChallengeQuestionFormState();
}

class _ChallengeQuestionFormState extends State<ChallengeQuestionForm> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text(context.l10n.challengeCreationTitleFormLabel),
                  AppTextField(
                    hintText: 'Défi fifa ⚽',
                    textController: _textController,
                  ),
                  const Gap.v(AppSpacing.lg),
                  ChallengeNextButton(
                    onPressed: () {
                      context.read<CreateChallengeBloc>().add(
                            CreateChallengeQuestionContinue(
                              question: _textController.text,
                            ),
                          );
                    },
                  ),
                  Tappable(
                    child: const Text('retour'),
                    onTap: () {
                      context.read<CreateChallengeBloc>().add(
                            const CreateChallengeBackIndex(),
                          );
                    },
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
