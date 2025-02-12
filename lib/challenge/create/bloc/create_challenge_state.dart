part of 'create_challenge_bloc.dart';

class CreateChallengeState extends Equatable {
  const CreateChallengeState._({
    required this.formIndex,
    required this.challengeTitle,
    required this.challengeQuestion,
  });

  const CreateChallengeState.initial()
      : this._(
          formIndex: 0,
          challengeTitle: '',
          challengeQuestion: '',
        );

  final int formIndex;
  final String challengeTitle;
  final String challengeQuestion;

  @override
  List<Object> get props => [
        formIndex,
        challengeTitle,
        challengeQuestion,
      ];

  CreateChallengeState copyWith({
    int? formIndex,
    String? challengeTitle,
    String? challengeQuestion,
  }) {
    return CreateChallengeState._(
      formIndex: formIndex ?? this.formIndex,
      challengeTitle: challengeTitle ?? this.challengeTitle,
      challengeQuestion: challengeQuestion ?? this.challengeQuestion,
    );
  }
}
