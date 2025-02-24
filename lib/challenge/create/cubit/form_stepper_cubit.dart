import 'dart:math';

import 'package:bloc/bloc.dart';

const maxSteps = 6;

class FormStepperCubit extends Cubit<int> {
  FormStepperCubit() : super(0);

  void nextStep() => emit(min(state + 1, maxSteps));
  void previousStep() => emit(max(state - 1, 0));
  void goTo(int index) => emit(index);
}
