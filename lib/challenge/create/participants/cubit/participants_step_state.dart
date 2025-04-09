part of 'participants_step_cubit.dart';

enum ParticipantsStepStatus { initial, success, error }

class ParticipantsStepState extends Equatable {
  const ParticipantsStepState({
    required this.status,
    required this.errorMessage,
    required this.participants,
  });

  const ParticipantsStepState.initial({
    List<Participant>? participants,
  }) : this(
          status: ParticipantsStepStatus.initial,
          errorMessage: null,
          participants: participants ?? const [],
        );

  final ParticipantsStepStatus status;
  final String? errorMessage;
  final List<Participant> participants;

  ParticipantsStepState copyWith({
    ParticipantsStepStatus? status,
    String? errorMessage,
    List<Participant>? participants,
  }) {
    return ParticipantsStepState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      participants: participants ?? this.participants,
    );
  }

  @override
  List<Object> get props => [
        status,
        errorMessage ?? '',
        participants,
      ];
}
