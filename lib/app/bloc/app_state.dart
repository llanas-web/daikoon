// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'app_bloc.dart';

/// {@template app_status}
/// The status of the application. Used to determine which page to show when
/// the application is started.
/// {@endtemplate}
enum AppStatus {
  /// The user is authenticated. Show `MainPage`.
  authenticated,

  /// The user is not authenticated or the authentication status is unknown.
  /// Show `AuthPage`.
  unauthenticated,

  /// The authentication status is unknown. Show `SplashPage`.
  onboardingRequired,
}

class AppState extends Equatable {
  const AppState({
    required this.status,
    this.user = User.anonymous,
    this.hasNotification = false,
  });

  const AppState.authenticated(User user)
      : this(
          status: AppStatus.authenticated,
          user: user,
          hasNotification: false,
        );

  const AppState.onboardingRequired(User user)
      : this(
          status: AppStatus.onboardingRequired,
          user: user,
          hasNotification: false,
        );

  const AppState.unauthenticated()
      : this(
          status: AppStatus.unauthenticated,
          user: User.anonymous,
          hasNotification: false,
        );

  final AppStatus status;
  final User user;
  final bool hasNotification;

  AppState copyWith({
    User? user,
    AppStatus? status,
    bool? hasNotification,
  }) {
    return AppState(
      user: user ?? this.user,
      status: status ?? this.status,
      hasNotification: hasNotification ?? this.hasNotification,
    );
  }

  @override
  List<Object> get props => [status, user, hasNotification];
}
