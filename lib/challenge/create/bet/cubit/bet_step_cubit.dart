import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bet_step_state.dart';

class BetStepCubit extends Cubit<BetStepState> {
  BetStepCubit() : super(const BetStepState.initial());

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
}
