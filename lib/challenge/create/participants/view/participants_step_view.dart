import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/app.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:user_repository/user_repository.dart';

class ParticipantsStepView extends StatelessWidget {
  const ParticipantsStepView({super.key});

  @override
  Widget build(BuildContext context) {
    final existingParticipants = context
        .select((CreateChallengeCubit cubit) => cubit.state.participants);

    final participantsCubit = ParticipantsStepCubit(
      userRepository: context.read<UserRepository>(),
      participants: existingParticipants,
    );

    return BlocProvider(
      create: (_) => participantsCubit,
      child: Column(
        children: [
          const Spacer(),
          Text(
            context.l10n.challengeCreationParticipantsFormLabel,
            style: UITextStyle.title,
          ),
          const ParticipantsFormField(),
          const ParticipantsList(),
          const Spacer(),
          ChallengeNextButton(
            onPressed: () {
              final state = participantsCubit.state;
              if (state.participants.isEmpty) {
                openSnackbar(
                  const SnackbarMessage.error(
                    title: 'Participants invalid',
                    description: 'Veuillez choisir au moins 1 participants',
                  ),
                );
                return;
              }
              context.read<CreateChallengeCubit>().updateParticipants(
                    state.participants,
                  );
              context.read<FormStepperCubit>().nextStep();
            },
          ),
          const ChallengePreviousButton(),
          const Spacer(),
        ].spacerBetween(height: AppSpacing.xxlg),
      ),
    );
  }
}
