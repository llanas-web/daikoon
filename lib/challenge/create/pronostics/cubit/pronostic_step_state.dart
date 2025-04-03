part of 'pronostic_step_cubit.dart';

enum PronosticStepStatus { initial, success, error }

class PronosticStepState extends Equatable {
  const PronosticStepState({
    required this.status,
    required this.errorMessage,
    required this.challengeQuestion,
    required this.choices,
  });

  const PronosticStepState.initial()
      : this(
          status: PronosticStepStatus.initial,
          errorMessage: null,
          challengeQuestion: const ChallengeQuestion.pure(),
          choices: const [],
        );

  final PronosticStepStatus status;
  final String? errorMessage;
  final ChallengeQuestion challengeQuestion;
  final List<String> choices;

  PronosticStepState copyWith({
    PronosticStepStatus? status,
    String? errorMessage,
    ChallengeQuestion? challengeQuestion,
    List<String>? choices,
  }) {
    return PronosticStepState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      challengeQuestion: challengeQuestion ?? this.challengeQuestion,
      choices: choices ?? this.choices,
    );
  }

  @override
  List<Object> get props => [
        status,
        challengeQuestion,
        choices,
      ];
}
