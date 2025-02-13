import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/create/bloc/create_challenge_bloc.dart';
import 'package:daikoon/challenge/create/widgets/widgets.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class ChallengeTitleForm extends StatefulWidget {
  const ChallengeTitleForm({super.key});

  @override
  State<ChallengeTitleForm> createState() => _ChallengeTitleFormState();
}

class _ChallengeTitleFormState extends State<ChallengeTitleForm> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    _textController.text =
        context.select((CreateChallengeBloc bloc) => bloc.state.challengeTitle);
    return Column(
      children: [
        Text(
          context.l10n.challengeCreationTitleFormLabel,
          style: context.headlineMedium,
        ),
        ChallengeTextFormField(
          hintText: context.l10n.challengeCreationTitleFormFieldHint,
          textController: _textController,
        ),
        ChallengeNextButton(
          onPressed: () {
            context.read<CreateChallengeBloc>().add(
                  CreateChallengeTitleContinued(
                    title: _textController.text,
                  ),
                );
          },
        ),
      ].spacerBetween(height: AppSpacing.xxlg),
    );
  }
}
