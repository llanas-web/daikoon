import 'dart:math';

import 'package:bloc/bloc.dart';

const maxSteps = 2;

class FormStepperCubit extends Cubit<int> {
  FormStepperCubit() : super(0);

  void nextStep() => emit(max(state + 1, maxSteps));
  void previousStep() => emit(min(state - 1, 0));
}
