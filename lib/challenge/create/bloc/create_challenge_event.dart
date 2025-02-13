part of 'create_challenge_bloc.dart';

sealed class CreateChallengeEvent extends Equatable {
  const CreateChallengeEvent();

  @override
  List<Object> get props => [];
}

final class CreateChallengeBackIndex extends CreateChallengeEvent {
  const CreateChallengeBackIndex();
}

final class UpdateChallengeTitle extends CreateChallengeEvent {
  const UpdateChallengeTitle({required this.title});

  final String title;
}

final class CreateChallengeTitleContinued extends CreateChallengeEvent {
  const CreateChallengeTitleContinued({required this.title});

  final String title;
}

final class CreateChallengeQuestionContinue extends CreateChallengeEvent {
  const CreateChallengeQuestionContinue({
    required this.question,
    required this.options,
  });

  final String question;
  final List<String> options;
}
