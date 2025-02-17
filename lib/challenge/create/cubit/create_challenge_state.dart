part of 'create_challenge_cubit.dart';

class CreateChallengeState extends Equatable {
  const CreateChallengeState._({
    required this.challengeTitle,
    required this.challengeQuestion,
    required this.options,
    required this.hasBet,
    required this.minAmount,
    required this.maxAmount,
    required this.noBetAmount,
    required this.participants,
    required this.startDate,
    required this.limitDate,
  });

  const CreateChallengeState.initial()
      : this._(
          challengeTitle: const ChallengeTitle.pure(),
          challengeQuestion: const ChallengeQuestion.pure(),
          options: const [],
          hasBet: false,
          minAmount: 0,
          maxAmount: 0,
          noBetAmount: false,
          participants: const [],
          startDate: null,
          limitDate: null,
        );

  final ChallengeTitle challengeTitle;
  final ChallengeQuestion challengeQuestion;
  final List<String> options;
  final bool hasBet;
  final int minAmount;
  final int maxAmount;
  final bool noBetAmount;
  final List<User> participants;
  final DateTime? startDate;
  final DateTime? limitDate;

  CreateChallengeState copyWith({
    ChallengeTitle? challengeTitle,
    ChallengeQuestion? challengeQuestion,
    List<String>? options,
    bool? hasBet,
    int? minAmount,
    int? maxAmount,
    bool? noBetAmount,
    List<User>? participants,
    DateTime? startDate,
    DateTime? limitDate,
  }) {
    return CreateChallengeState._(
      challengeTitle: challengeTitle ?? this.challengeTitle,
      challengeQuestion: challengeQuestion ?? this.challengeQuestion,
      options: options ?? this.options,
      hasBet: hasBet ?? this.hasBet,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      noBetAmount: noBetAmount ?? this.noBetAmount,
      participants: participants ?? this.participants,
      startDate: startDate ?? this.startDate,
      limitDate: limitDate ?? this.limitDate,
    );
  }

  @override
  List<Object?> get props => [
        challengeTitle,
        challengeQuestion,
        options,
        hasBet,
        minAmount,
        maxAmount,
        noBetAmount,
        participants,
        startDate,
        limitDate,
      ];
}
