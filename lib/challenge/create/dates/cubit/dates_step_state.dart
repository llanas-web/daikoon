part of 'dates_step_cubit.dart';

enum DatesStepStatus { initial, success, failure }

class DatesStepState extends Equatable {
  const DatesStepState({
    required this.status,
    required this.errorMessage,
    required this.startDate,
    required this.endDate,
    required this.limitDate,
  });

  const DatesStepState.initial()
      : this(
          status: DatesStepStatus.initial,
          errorMessage: null,
          startDate: null,
          endDate: null,
          limitDate: null,
        );

  final DatesStepStatus status;
  final String? errorMessage;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? limitDate;

  DatesStepState copyWith({
    DatesStepStatus? status,
    String? errorMessage,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? limitDate,
  }) {
    return DatesStepState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      limitDate: limitDate ?? this.limitDate,
    );
  }

  @override
  List<Object> get props => [
        startDate ?? DateTime.now(),
        endDate ?? DateTime.now(),
        limitDate ?? DateTime.now(),
        status,
        errorMessage ?? '',
      ];
}
