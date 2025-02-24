import 'package:bloc/bloc.dart';
import 'package:challenge_repository/challenge_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:form_fields/form_fields.dart';
import 'package:shared/shared.dart';
import 'package:user_repository/user_repository.dart';

part 'create_challenge_state.dart';

class CreateChallengeCubit extends Cubit<CreateChallengeState> {
  CreateChallengeCubit({
    required ChallengeRepository challengeRepository,
  })  : _challengeRepository = challengeRepository,
        super(const CreateChallengeState.initial());

  final ChallengeRepository _challengeRepository;

  /// Emits initial state of challenge creation screen.
  void resetState() => emit(const CreateChallengeState.initial());

  /// Title value was changed, triggering new changes in state.
  void onTitleChanged(String newValue) {
    final previousState = state;
    final newTitle = newValue;
    final shouldValidate = previousState.challengeTitle.invalid;
    final newChallengeTitle = shouldValidate
        ? ChallengeTitle.dirty(
            newTitle,
          )
        : ChallengeTitle.pure(
            newTitle,
          );

    final newState = previousState.copyWith(
      challengeTitle: newChallengeTitle,
    );
    emit(newState);
  }

  void onQuestionChanged(String newValue) {
    final previousState = state;
    final newQuestion = newValue;
    final shouldValidate = previousState.challengeQuestion.invalid;
    final newChallengeQuestion = shouldValidate
        ? ChallengeQuestion.dirty(
            newQuestion,
          )
        : ChallengeQuestion.pure(
            newQuestion,
          );

    final newState = previousState.copyWith(
      challengeQuestion: newChallengeQuestion,
    );
    emit(newState);
  }

  void onChoicesAdded(String newChoice) {
    final previousState = state;
    final newChoices = List<String>.from(previousState.choices)..add(newChoice);
    final newState = previousState.copyWith(
      choices: newChoices,
    );
    emit(newState);
  }

  void onChoicesRemoved(int index) {
    final previousState = state;
    final newChoices = List<String>.from(previousState.choices)
      ..removeAt(index);
    final newState = previousState.copyWith(
      choices: newChoices,
    );
    emit(newState);
  }

  void onSetHasBet({bool? hasBet}) {
    final previousState = state;
    final newState = previousState.copyWith(
      hasBet: hasBet ?? !previousState.hasBet,
    );
    emit(newState);
  }

  void onMinAmountChanged(int newMinAmount) {
    final previousState = state;
    final newState = previousState.copyWith(
      minAmount: newMinAmount,
      noBetAmount: false,
    );
    emit(newState);
  }

  void onMaxAmountChanged(int newMaxAmount) {
    final previousState = state;
    final newState = previousState.copyWith(
      maxAmount: newMaxAmount,
      noBetAmount: false,
    );
    emit(newState);
  }

  void onNoBetAmount({bool? isSelected}) {
    final previousState = state;
    final newState = previousState.copyWith(
      noBetAmount: isSelected ?? !previousState.noBetAmount,
    );
    emit(newState);
  }

  void onParticipantAdded(User user) {
    final previousState = state;
    final newParticipants = List<Participant>.from(previousState.participants)
      ..add(Participant(user: user));
    final newState = previousState.copyWith(
      participants: newParticipants,
    );
    emit(newState);
  }

  void onParticipantRemoved(User user) {
    final previousState = state;
    final newParticipants = List<Participant>.from(previousState.participants)
      ..removeWhere((participant) => participant.id == user.id);
    final newState = previousState.copyWith(
      participants: newParticipants,
    );
    emit(newState);
  }

  void onStartDateChanged(DateTime startDate) {
    final previousState = state;
    final selectedDate = state.startDate ?? DateTime.now();
    final selectedDateTime = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      selectedDate.hour,
      selectedDate.minute,
    );
    final newState = previousState.copyWith(
      startDate: selectedDateTime,
    );
    emit(newState);
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
      throw Exception('Start date cannot be in the past');
    }
    if (previousState.limitDate != null &&
        selectedDateTime.isAfter(previousState.limitDate!)) {
      throw Exception('Start date cannot be after limit date');
    }
    if (previousState.endDate != null &&
        selectedDateTime.isAfter(previousState.endDate!)) {
      throw Exception('Start date cannot be after end date');
    }
    final newState = previousState.copyWith(
      startDate: selectedDateTime,
    );
    emit(newState);
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
      throw Exception('Limit date cannot be in the past');
    }
    if (previousState.startDate != null &&
        selectedDateTime.isBefore(previousState.startDate!)) {
      throw Exception('Limit date cannot be before start date');
    }
    if (previousState.endDate != null &&
        selectedDateTime.isAfter(previousState.endDate!)) {
      throw Exception('Limit date cannot be after end date');
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

  void onEndTimeChanged(TimeOfDay endTime) {
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
      throw Exception('End date cannot be in the past');
    }
    if (previousState.startDate != null &&
        selectedDateTime.isBefore(previousState.startDate!)) {
      throw Exception('End date cannot be before start date');
    }
    if (previousState.limitDate != null &&
        selectedDateTime.isBefore(previousState.limitDate!)) {
      throw Exception('End date cannot be before limit date');
    }
    final newState = previousState.copyWith(
      endDate: selectedDateTime,
    );
    emit(newState);
  }

  void submit({
    required User creator,
  }) {
    final previousState = state;
    final newChallenge = Challenge(
      title: previousState.challengeTitle.value,
      question: previousState.challengeQuestion.value,
      choices:
          previousState.choices.map((choice) => Choice(value: choice)).toList(),
      hasBet: previousState.hasBet,
      minBet: previousState.minAmount,
      maxBet: previousState.maxAmount,
      participants: previousState.participants,
      starting: previousState.startDate,
      limitDate: previousState.limitDate,
      ending: previousState.endDate,
    );
    _challengeRepository.createChallenge(
      challenge: newChallenge,
      creator: creator,
      choices: newChallenge.choices,
      participants: newChallenge.participants,
    );
  }
}
