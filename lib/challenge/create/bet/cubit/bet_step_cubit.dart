import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bet_step_state.dart';

class BetStepCubit extends Cubit<BetStepState> {
  BetStepCubit({
    int? minAmount,
    int? maxAmount,
    bool noBetAmount = false,
  }) : super(
          BetStepState.initial(
            minAmount: minAmount,
            maxAmount: maxAmount,
            noBetAmount: noBetAmount,
          ),
        );

  void onMinAmountChanged(int? minAmount) {
    final previousState = state;
    emit(
      previousState.copyWith(
        minAmount: minAmount,
        status: BetStepStatus.success,
      ),
    );
  }

  void onMaxAmountChanged(int? maxAmount) {
    final previousState = state;
    emit(
      previousState.copyWith(
        maxAmount: maxAmount,
        status: BetStepStatus.success,
      ),
    );
  }

  void onNoBetAmountChanged({required bool noBetAmount}) {
    final previousState = state;
    emit(
      previousState.copyWith(
        noBetAmount: noBetAmount,
        status: BetStepStatus.success,
      ),
    );
  }

  bool validateStep() {
    final isValid = !state.noBetAmount ||
        (state.minAmount != null && state.maxAmount != null);

    emit(
      state.copyWith(
        status: isValid ? BetStepStatus.success : BetStepStatus.error,
        errorMessage: isValid ? null : 'Invalid bet amount',
      ),
    );

    return isValid;
  }
}
