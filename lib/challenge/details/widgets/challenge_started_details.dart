import 'package:daikoon/challenge/challenge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class ChallengeStartedDetails extends StatelessWidget {
  const ChallengeStartedDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChallengeDetailsCubit, ChallengeDetailsState>(
      builder: (context, state) {
        final userParticipation =
            context.read<ChallengeDetailsCubit>().userParticipation;

        if (state.status == ChallengeDetailsStatus.loading ||
            userParticipation == null) {
          return const Center(child: CircularProgressIndicator());
        }

        switch (userParticipation.status) {
          case ParticipantStatus.pending:
            return const ChallengeInvitationPending();
          case ParticipantStatus.accepted:
            return const ChallengeInvitationAccepted();
          case ParticipantStatus.declined:
            return const ChallengeInvitationDeclined();
        }
      },
    );
  }
}
