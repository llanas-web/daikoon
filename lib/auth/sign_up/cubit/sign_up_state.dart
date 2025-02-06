part of 'sign_up_cubit.dart';

/// Message that will be shown to user, when he will try to submit signup form,
/// but there is an error occurred. It is used to show user, what exactly went
/// wrong.
typedef SingUpErrorMessage = String;

/// Defines possible signup submission statuses. It is used to manipulate with
/// state, using Bloc, according to state. Therefore, when [success] we
/// can simply navigate user to main page and such.
enum SignUpSubmissionStatus {
  /// [SignUpSubmissionStatus.idle] indicates that user has not yet submitted
  /// signup form.
  idle,

  /// [SignUpSubmissionStatus.inProgress] indicates that user has submitted
  /// signup form and is currently waiting for response from backend.
  inProgress,

  /// [SignUpSubmissionStatus.googleAuthInProgress] indicates that user has
  /// submitted login with google.
  googleAuthInProgress,

  /// [SignUpSubmissionStatus.success] indicates that user has successfully
  /// submitted signup form and is currently waiting for response from backend.
  success,

  /// [SignUpSubmissionStatus.emailAlreadyRegistered] indicates that email,
  /// provided by user, is occupied by another one in database.
  emailAlreadyRegistered,

  /// [SignUpSubmissionStatus.inProgress] indicates that user had no internet
  /// connection during network request.
  networkError,

  /// [SignUpSubmissionStatus.error] indicates something went wrong when user
  /// tried to sign up.
  error,

  /// [SignUpSubmissionStatus.googleLogInFailure] indicates that some went
  /// wrong during google login process.
  googleLogInFailure;

  bool get isSuccess => this == SignUpSubmissionStatus.success;
  bool get isLoading => this == SignUpSubmissionStatus.inProgress;
  bool get isGoogleAuthInProgress =>
      this == SignUpSubmissionStatus.googleAuthInProgress;
  bool get isEmailRegistered =>
      this == SignUpSubmissionStatus.emailAlreadyRegistered;
  bool get isNetworkError => this == SignUpSubmissionStatus.networkError;
  bool get isError =>
      this == SignUpSubmissionStatus.error ||
      isNetworkError ||
      isEmailRegistered;
}

class SignUpState extends Equatable {
  const SignUpState._({
    required this.email,
    required this.username,
    required this.password,
    required this.showPassword,
    required this.submissionStatus,
    required this.message,
  });

  const SignUpState.initial()
      : this._(
          email: const Email.pure(),
          username: const Username.pure(),
          password: const Password.pure(),
          showPassword: false,
          submissionStatus: SignUpSubmissionStatus.idle,
          message: '',
        );

  final Email email;
  final Username username;
  final Password password;
  final bool showPassword;
  final SignUpSubmissionStatus submissionStatus;
  final SingUpErrorMessage message;

  SignUpState copyWith({
    Email? email,
    Username? username,
    Password? password,
    bool? showPassword,
    SignUpSubmissionStatus? submissionStatus,
    SingUpErrorMessage? message,
  }) {
    return SignUpState._(
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      showPassword: showPassword ?? this.showPassword,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        email,
        password,
        username,
        submissionStatus,
        showPassword,
      ];
}

final signupSubmissionStatusMessage =
    <SignUpSubmissionStatus, SubmissionStatusMessage>{
  SignUpSubmissionStatus.emailAlreadyRegistered: const SubmissionStatusMessage(
    title: 'User with this email already exists.',
    description: 'Try another email address.',
  ),
  SignUpSubmissionStatus.error: const SubmissionStatusMessage.genericError(),
  SignUpSubmissionStatus.networkError:
      const SubmissionStatusMessage.networkError(),
  SignUpSubmissionStatus.googleLogInFailure: const SubmissionStatusMessage(
    title: 'Google login failed!',
    description: 'Try again later.',
  ),
};
