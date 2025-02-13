part of 'create_challenge_cubit.dart';

class CreateChallengeState extends Equatable {
  const CreateChallengeState._({
    required this.challengeTitle,
    required this.challengeQuestion,
    required this.options,
  });

  const CreateChallengeState.initial()
      : this._(
          challengeTitle: const ChallengeTitle.pure(),
          challengeQuestion: const ChallengeQuestion.pure(),
          options: const [],
        );

  final ChallengeTitle challengeTitle;
  final ChallengeQuestion challengeQuestion;
  final List<String> options;

  CreateChallengeState copyWith({
    ChallengeTitle? challengeTitle,
    ChallengeQuestion? challengeQuestion,
    List<String>? options,
  }) {
    return CreateChallengeState._(
      challengeTitle: challengeTitle ?? this.challengeTitle,
      challengeQuestion: challengeQuestion ?? this.challengeQuestion,
      options: options ?? this.options,
    );
  }

  @override
  List<Object?> get props => [challengeTitle, challengeQuestion, options];
}
