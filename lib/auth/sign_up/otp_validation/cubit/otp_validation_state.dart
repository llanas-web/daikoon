part of 'otp_validation_cubit.dart';

enum OtpValidationStatus {
  initial,
  loading,
  success,
  failure,
  invalidOtp;

  bool get isInitial => this == OtpValidationStatus.initial;
  bool get isLoading => this == OtpValidationStatus.loading;
  bool get isSuccess => this == OtpValidationStatus.success;
  bool get isFailure => this == OtpValidationStatus.failure || isInvalidOtp;
  bool get isInvalidOtp => this == OtpValidationStatus.invalidOtp;
}

class OtpValidationState extends Equatable {
  const OtpValidationState._({
    required this.status,
    required this.email,
    required this.otp,
  });

  const OtpValidationState.initial()
      : this._(
          status: OtpValidationStatus.initial,
          email: const Email.pure(),
          otp: const Otp.pure(),
        );

  final OtpValidationStatus status;
  final Email email;
  final Otp otp;

  @override
  List<Object> get props => [
        status,
        email,
        otp,
      ];

  OtpValidationState copyWith({
    OtpValidationStatus? status,
    Email? email,
    Otp? otp,
  }) {
    return OtpValidationState._(
      status: status ?? this.status,
      email: email ?? this.email,
      otp: otp ?? this.otp,
    );
  }
}

final otpValidationSatusMessage =
    <OtpValidationStatus, SubmissionStatusMessage>{
  OtpValidationStatus.failure: const SubmissionStatusMessage.genericError(),
  OtpValidationStatus.invalidOtp: const SubmissionStatusMessage(
    title: 'Invalid OTP. Please check and re-enter the code.',
  ),
};
