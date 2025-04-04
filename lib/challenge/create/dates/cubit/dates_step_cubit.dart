import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'dates_step_state.dart';

class DatesStepCubit extends Cubit<DatesStepState> {
  DatesStepCubit() : super(const DatesStepState.initial());

  void onStartDateChanged(DateTime startDate) {
    final selectedDate = state.startDate ?? DateTime.now();
    final selectedDateTime = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      selectedDate.hour,
      selectedDate.minute,
    );
    emit(
      state.copyWith(
        startDate: selectedDateTime,
        status: DatesStepStatus.success,
      ),
    );
  }

  void onStartTimeChanged(TimeOfDay startTime) {
    final previousState = state;
    final selectedDate = state.startDate ?? DateTime.now();
    final selectedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      startTime.hour,
      startTime.minute,
    );
    if (selectedDateTime.isBefore(DateTime.now())) {
      emit(
        previousState.copyWith(
          status: DatesStepStatus.failure,
          errorMessage: 'Start date cannot be in the past',
        ),
      );
      return;
    }
    if (previousState.limitDate != null &&
        selectedDateTime.isAfter(previousState.limitDate!)) {
      emit(
        previousState.copyWith(
          status: DatesStepStatus.failure,
          errorMessage: 'Start date cannot be after limit date',
        ),
      );
      return;
    }
    if (previousState.endDate != null &&
        selectedDateTime.isAfter(previousState.endDate!)) {
      emit(
        previousState.copyWith(
          status: DatesStepStatus.failure,
          errorMessage: 'Start date cannot be after end date',
        ),
      );
      return;
    }
    emit(previousState.copyWith(startDate: selectedDateTime));
  }

  void onLimitDateChanged(DateTime limitDate) {
    final previousState = state;
    final selectedDate = state.limitDate ?? DateTime.now();
    final selectedDateTime = DateTime(
      limitDate.year,
      limitDate.month,
      limitDate.day,
      selectedDate.hour,
      selectedDate.minute,
    );
    final newState = previousState.copyWith(
      limitDate: selectedDateTime,
    );
    emit(newState);
  }

  void onLimitTimeChanged(TimeOfDay limitTime) {
    final previousState = state;
    final selectedDate = state.limitDate ?? DateTime.now();
    final selectedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      limitTime.hour,
      limitTime.minute,
    );
    if (selectedDateTime.isBefore(DateTime.now())) {
      emit(
        previousState.copyWith(
          status: DatesStepStatus.failure,
          errorMessage: 'Limit date cannot be in the past',
        ),
      );
      return;
    }
    if (previousState.startDate != null &&
        selectedDateTime.isBefore(previousState.startDate!)) {
      emit(
        previousState.copyWith(
          status: DatesStepStatus.failure,
          errorMessage: 'Limit date cannot be before start date',
        ),
      );
      return;
    }
    if (previousState.endDate != null &&
        selectedDateTime.isAfter(previousState.endDate!)) {
      emit(
        previousState.copyWith(
          status: DatesStepStatus.failure,
          errorMessage: 'Limit date cannot be after end date',
        ),
      );
      return;
    }
    final newState = previousState.copyWith(
      limitDate: selectedDateTime,
    );
    emit(newState);
  }

  void onEndDateChanged(DateTime endDate) {
    final previousState = state;
    final selectedDate = state.endDate ?? DateTime.now();
    final selectedDateTime = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
      selectedDate.hour,
      selectedDate.minute,
    );
    final newState = previousState.copyWith(
      endDate: selectedDateTime,
    );
    emit(newState);
  }

  Future<void> onEndTimeChanged(TimeOfDay endTime) async {
    final previousState = state;
    final selectedDate = state.endDate ?? DateTime.now();
    final selectedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      endTime.hour,
      endTime.minute,
    );
    if (selectedDateTime.isBefore(DateTime.now())) {
      emit(
        previousState.copyWith(
          status: DatesStepStatus.failure,
          errorMessage: 'End date cannot be in the past',
        ),
      );
      return;
    }
    if (previousState.startDate != null &&
        selectedDateTime.isBefore(previousState.startDate!)) {
      emit(
        previousState.copyWith(
          status: DatesStepStatus.failure,
          errorMessage: 'End date cannot be before start date',
        ),
      );
      return;
    }
    if (previousState.limitDate != null &&
        selectedDateTime.isBefore(previousState.limitDate!)) {
      emit(
        previousState.copyWith(
          status: DatesStepStatus.failure,
          errorMessage: 'End date cannot be before limit date',
        ),
      );
      return;
    }
    final newState = previousState.copyWith(
      endDate: selectedDateTime,
    );
    emit(newState);
  }
}
