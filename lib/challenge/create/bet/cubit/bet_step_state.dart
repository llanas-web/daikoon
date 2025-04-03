part of 'bet_step_cubit.dart';

enum BetStepStatus { initial, success, error }

class BetStepState extends Equatable {
  const BetStepState({
    required this.status,
    required this.errorMessage,
    required this.noBetAmount,
    this.minAmount,
    this.maxAmount,
  });

  const BetStepState.initial()
      : this(
          status: BetStepStatus.initial,
          errorMessage: null,
          minAmount: null,
          maxAmount: null,
          noBetAmount: false,
        );

  final BetStepStatus status;
  final String? errorMessage;
  final int? minAmount;
  final int? maxAmount;
  final bool noBetAmount;

  BetStepState copyWith({
    BetStepStatus? status,
    String? errorMessage,
    int? minAmount,
    int? maxAmount,
    bool? noBetAmount,
  }) {
    return BetStepState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      noBetAmount: noBetAmount ?? this.noBetAmount,
    );
  }

  @override
  List<Object> get props => [
        minAmount ?? 0,
        maxAmount ?? 0,
        noBetAmount,
      ];
}
