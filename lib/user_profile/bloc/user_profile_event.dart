// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_profile_bloc.dart';

sealed class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object> get props => [];
}

final class UserProfileUpdateRequested extends UserProfileEvent {
  const UserProfileUpdateRequested({
    this.fullName,
    this.email,
    this.username,
    this.avatarUrl,
    this.pushToken,
  });

  final String? fullName;
  final String? email;
  final String? username;
  final String? avatarUrl;
  final String? pushToken;
}

final class UserProfileSubscriptionRequested extends UserProfileEvent {
  const UserProfileSubscriptionRequested({this.userId});

  final String? userId;
}

final class UserProfileDaikoinsRequested extends UserProfileEvent {
  const UserProfileDaikoinsRequested();
}
