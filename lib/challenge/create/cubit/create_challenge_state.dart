part of 'create_challenge_cubit.dart';

class CreateChallengeState extends Equatable {
  const CreateChallengeState._({
    required this.challengeTitle,
    required this.challengeQuestion,
    required this.choices,
    required this.hasBet,
    required this.minAmount,
    required this.maxAmount,
    required this.noBetAmount,
    required this.participants,
    required this.startDate,
    required this.limitDate,
    required this.endDate,
  });

  const CreateChallengeState.initial()
      : this._(
          challengeTitle: const ChallengeTitle.pure(),
          challengeQuestion: const ChallengeQuestion.pure(),
          choices: const [],
          hasBet: false,
          minAmount: 0,
          maxAmount: 0,
          noBetAmount: false,
          participants: const [],
          startDate: null,
          limitDate: null,
          endDate: null,
        );

  final ChallengeTitle challengeTitle;
  final ChallengeQuestion challengeQuestion;
  final List<String> choices;
  final bool hasBet;
  final int minAmount;
  final int maxAmount;
  final bool noBetAmount;
  final List<Participant> participants;
  final DateTime? startDate;
  final DateTime? limitDate;
  final DateTime? endDate;

  CreateChallengeState copyWith({
    ChallengeTitle? challengeTitle,
    ChallengeQuestion? challengeQuestion,
    List<String>? choices,
    bool? hasBet,
    int? minAmount,
    int? maxAmount,
    bool? noBetAmount,
    List<Participant>? participants,
    DateTime? startDate,
    DateTime? limitDate,
    DateTime? endDate,
  }) {
    return CreateChallengeState._(
      challengeTitle: challengeTitle ?? this.challengeTitle,
      challengeQuestion: challengeQuestion ?? this.challengeQuestion,
      choices: choices ?? this.choices,
      hasBet: hasBet ?? this.hasBet,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      noBetAmount: noBetAmount ?? this.noBetAmount,
      participants: participants ?? this.participants,
      startDate: startDate ?? this.startDate,
      limitDate: limitDate ?? this.limitDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  List<Object?> get props => [
        challengeTitle,
        challengeQuestion,
        choices,
        hasBet,
        minAmount,
        maxAmount,
        noBetAmount,
        participants,
        startDate,
        limitDate,
        endDate,
      ];
}
