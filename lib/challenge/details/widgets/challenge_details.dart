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
    final userBet = context.select(
      (ChallengeDetailsCubit cubit) => cubit.userBet,
    );
    if (challengeDetails.isEnded) {
      return const ChallengeEndedDetails();
    } else if (userBet != null || challengeDetails.isLimited) {
      return const ChallengeLimitDetails();
    } else {
      return const ChallengeStartedDetails();
    }
  }
}
