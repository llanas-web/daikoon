part of 'pronostic_step_cubit.dart';

enum PronosticStepStatus { initial, success, error }

class PronosticStepState extends Equatable {
  const PronosticStepState({
    required this.status,
    required this.errorMessage,
    required this.challengeQuestion,
    required this.choices,
    required this.newChoiceInput,
  });

  PronosticStepState.initial({
    String? question,
    List<String>? choices,
  }) : this(
          status: PronosticStepStatus.initial,
          errorMessage: null,
          challengeQuestion: question != null
              ? ChallengeQuestion.dirty(question)
              : const ChallengeQuestion.pure(),
          choices: choices ?? const [],
          newChoiceInput: null,
        );

  final PronosticStepStatus status;
  final String? errorMessage;
  final ChallengeQuestion challengeQuestion;
  final List<String> choices;
  final String? newChoiceInput;

  PronosticStepState copyWith({
    PronosticStepStatus? status,
    String? errorMessage,
    ChallengeQuestion? challengeQuestion,
    List<String>? choices,
    String? newChoiceInput,
  }) {
    return PronosticStepState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      challengeQuestion: challengeQuestion ?? this.challengeQuestion,
      choices: choices ?? this.choices,
      newChoiceInput: newChoiceInput ?? this.newChoiceInput,
    );
  }

  @override
  List<Object> get props => [
        status,
        challengeQuestion,
        choices,
        newChoiceInput ?? '',
      ];
}
