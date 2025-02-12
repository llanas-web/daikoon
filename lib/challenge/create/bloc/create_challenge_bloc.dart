import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_challenge_event.dart';
part 'create_challenge_state.dart';

class CreateChallengeBloc
    extends Bloc<CreateChallengeEvent, CreateChallengeState> {
  CreateChallengeBloc() : super(const CreateChallengeState.initial()) {
    on<CreateChallengeBackIndex>((event, emit) {
      emit(state.copyWith(formIndex: max(state.formIndex - 1, 0)));
    });
    on<CreateChallengeTitleContinued>((event, emit) {
      emit(state.copyWith(challengeTitle: event.title, formIndex: 1));
    });
    on<CreateChallengeQuestionContinue>((event, emit) {
      emit(state.copyWith(challengeQuestion: event.question, formIndex: 2));
    });
  }
}
