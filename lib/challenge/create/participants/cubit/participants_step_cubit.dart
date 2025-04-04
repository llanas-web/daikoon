import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/shared.dart';
import 'package:user_repository/user_repository.dart';

part 'participants_step_state.dart';

class ParticipantsStepCubit extends Cubit<ParticipantsStepState> {
  ParticipantsStepCubit({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const ParticipantsStepState.initial());

  final UserRepository _userRepository;

  List<String> get participantsNames => state.participants
      .map((participant) => participant.displayUsername)
      .toList();

  Future<List<User>> searchNewParticipants(String query) {
    final participantsIds = state.participants.map((p) => p.id).toList();
    return _userRepository.searchFriends(
      query: query,
      excludeUserIds: participantsIds,
    );
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
}
