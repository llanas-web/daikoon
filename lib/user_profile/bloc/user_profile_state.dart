part of 'user_profile_bloc.dart';

enum UserProfileStatus {
  initial,
  userUpdated,
  userUpdateFailed;

  bool get isUpdateSuccess => this == UserProfileStatus.userUpdated;
  bool get isUpdateError => this == UserProfileStatus.userUpdateFailed;
}

class UserProfileState extends Equatable {
  const UserProfileState._({
    required this.status,
    required this.user,
    required this.daikoins,
  });

  const UserProfileState.initial()
      : this._(
          status: UserProfileStatus.initial,
          user: User.anonymous,
          daikoins: 0,
        );

  final UserProfileStatus status;
  final User user;
  final int daikoins;

  @override
  List<Object> get props => [
        status,
        user,
        daikoins,
      ];

  UserProfileState copyWith({
    UserProfileStatus? status,
    User? user,
    int? daikoins,
  }) {
    return UserProfileState._(
      status: status ?? this.status,
      user: user ?? this.user,
      daikoins: daikoins ?? this.daikoins,
    );
  }
}

final userProfileStatusMessage = <UserProfileStatus, SubmissionStatusMessage>{
  UserProfileStatus.userUpdateFailed:
      const SubmissionStatusMessage.genericError(),
};
