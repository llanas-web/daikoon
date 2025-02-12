import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/shared.dart';
import 'package:user_repository/user_repository.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc({
    required UserRepository userRepository,
    String? userId,
  })  : _userRepository = userRepository,
        _userId = userId ?? userRepository.currentUserId ?? '',
        super(const UserProfileState.initial()) {
    on<UserProfileSubscriptionRequested>(
      _onUserProfileSubscriptionRequested,
    );
    on<UserProfileUpdateRequested>(
      _onUserProfileUpdateRequested,
    );
    on<UserProfileDaikoinsRequested>(
      _onDaikoinsFetch,
    );
    on<UserProfileFriendRequested>(
      _onFriendRequested,
    );
    on<UserProfileUnfriendRequested>(
      _onUnfriendRequested,
    );
  }

  final String _userId;
  final UserRepository _userRepository;

  bool get isOwner => _userRepository.currentUserId == _userId;

  Stream<List<User>> get friends => _userRepository.getFriends(userId: _userId);

  Stream<bool> friendshipStatus({required String friendId}) =>
      _userRepository.friendshipStatus(friendId: friendId).asBroadcastStream();

  Future<void> _onUserProfileSubscriptionRequested(
    UserProfileSubscriptionRequested event,
    Emitter<UserProfileState> emit,
  ) async {
    await emit.forEach(
      isOwner ? _userRepository.user : _userRepository.profile(userId: _userId),
      onData: (user) => state.copyWith(user: user),
    );
  }

  Future<void> _onUserProfileUpdateRequested(
    UserProfileUpdateRequested event,
    Emitter<UserProfileState> emit,
  ) async {
    try {
      emit(state.copyWith(status: UserProfileStatus.initial));
      await _userRepository.updateUser(
        email: event.email,
        username: event.username,
        avatarUrl: event.avatarUrl,
        fullName: event.fullName,
        pushToken: event.pushToken,
      );
      emit(state.copyWith(status: UserProfileStatus.userUpdated));
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(state.copyWith(status: UserProfileStatus.userUpdateFailed));
    }
  }

  Future<void> _onDaikoinsFetch(
    UserProfileDaikoinsRequested event,
    Emitter<UserProfileState> emit,
  ) async {
    await emit.forEach(
      _userRepository.daikoins(userId: _userId),
      onData: (daikoins) => state.copyWith(daikoins: daikoins),
    );
  }

  Future<void> _onFriendRequested(
    UserProfileFriendRequested event,
    Emitter<UserProfileState> emit,
  ) async {
    try {
      await _userRepository.addFriend(friendId: event.friendId);
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> _onUnfriendRequested(
    UserProfileUnfriendRequested event,
    Emitter<UserProfileState> emit,
  ) async {
    await _userRepository.removeFriend(
      userId: _userId,
      friendId: event.friendId,
    );
  }
}
