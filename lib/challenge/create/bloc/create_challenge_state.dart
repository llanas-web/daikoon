part of 'create_challenge_bloc.dart';

class CreateChallengeState extends Equatable {
  const CreateChallengeState._({
    required this.formIndex,
    required this.challengeTitle,
    required this.challengeQuestion,
    required this.options,
  });

  const CreateChallengeState.initial()
      : this._(
          formIndex: 0,
          challengeTitle: '',
          challengeQuestion: '',
          options: const [],
        );

  final int formIndex;
  final String challengeTitle;
  final String challengeQuestion;
  final List<String> options;

  @override
  List<Object> get props => [
        formIndex,
        challengeTitle,
        challengeQuestion,
        options,
      ];

  CreateChallengeState copyWith({
    int? formIndex,
    String? challengeTitle,
    String? challengeQuestion,
    List<String>? options,
  }) {
    return CreateChallengeState._(
      formIndex: formIndex ?? this.formIndex,
      challengeTitle: challengeTitle ?? this.challengeTitle,
      challengeQuestion: challengeQuestion ?? this.challengeQuestion,
      options: options ?? this.options,
    );
  }
}
