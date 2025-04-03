part of 'title_step_cubit.dart';

enum TitleStepStatus { initial, success, error }

class TitleStepState extends Equatable {
  const TitleStepState({
    required this.status,
    required this.errorMessage,
    required this.challengeTitle,
  });

  const TitleStepState.initial()
      : this(
          status: TitleStepStatus.initial,
          errorMessage: null,
          challengeTitle: const ChallengeTitle.pure(),
        );

  final TitleStepStatus status;
  final String? errorMessage;
  final ChallengeTitle challengeTitle;

  TitleStepState copyWith({
    TitleStepStatus? status,
    String? errorMessage,
    ChallengeTitle? challengeTitle,
  }) {
    return TitleStepState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      challengeTitle: challengeTitle ?? this.challengeTitle,
    );
  }

  @override
  List<Object> get props => [
        status,
        challengeTitle,
      ];
}
