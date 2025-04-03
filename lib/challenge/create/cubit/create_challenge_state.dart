part of 'create_challenge_cubit.dart';

enum CreateChallengeStatus { initial, loading, success, error }

class CreateChallengeState extends Equatable {
  const CreateChallengeState._({
    required this.status,
    required this.errorMessage,
    required this.challengeId,
    required this.title,
    required this.question,
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
          status: CreateChallengeStatus.initial,
          errorMessage: null,
          challengeId: null,
          title: null,
          question: null,
          choices: const [],
          hasBet: false,
          minAmount: null,
          maxAmount: null,
          noBetAmount: false,
          participants: const [],
          startDate: null,
          limitDate: null,
          endDate: null,
        );

  final CreateChallengeStatus status;
  final String? errorMessage;
  final String? challengeId;
  final String? title;
  final String? question;
  final List<String> choices;
  final bool hasBet;
  final int? minAmount;
  final int? maxAmount;
  final bool noBetAmount;
  final List<Participant> participants;
  final DateTime? startDate;
  final DateTime? limitDate;
  final DateTime? endDate;

  CreateChallengeState copyWith({
    CreateChallengeStatus? status,
    String? errorMessage,
    String? challengeId,
    String? title,
    String? question,
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
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      challengeId: challengeId ?? this.challengeId,
      title: title ?? this.title,
      question: question ?? this.question,
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
        status,
        challengeId,
        title,
        question,
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
