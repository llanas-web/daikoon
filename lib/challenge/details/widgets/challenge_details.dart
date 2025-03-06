import 'package:daikoon/challenge/details/challenge_details.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChallengeDetails extends StatelessWidget {
  const ChallengeDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final challengeDetails = context.select(
      (ChallengeDetailsCubit cubit) => cubit.state.challenge,
    )!;
    if (challengeDetails.isEnded) {
      return const ChallengeEndedDetails();
    } else if (!challengeDetails.isStarted) {
      return const ChallengeLimitDetails();
    } else {
      return const ChallengeStartedDetails();
    }
  }
}
