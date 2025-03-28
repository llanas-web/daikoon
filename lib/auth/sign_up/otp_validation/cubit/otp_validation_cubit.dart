import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_fields/form_fields.dart';
import 'package:shared/shared.dart';
import 'package:user_repository/user_repository.dart';

part 'otp_validation_state.dart';

class OtpValidationCubit extends Cubit<OtpValidationState> {
  OtpValidationCubit({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const OtpValidationState.initial());

  final UserRepository _userRepository;

  void resetState() => emit(const OtpValidationState.initial());

  void setEmail(String email) {
    final previousState = state;
    final newEmail = Email.dirty(email);
    final newState = previousState.copyWith(email: newEmail);
    emit(newState);
  }

  void onOtpUnfocused() {
    final previousState = state;
    final previousOtp = previousState.otp;
    final newOtp = Otp.dirty(previousOtp.value);
    final newState = previousState.copyWith(otp: newOtp);
    emit(newState);
  }

  void onOtpChanged(String newValue) {
    final previousState = state;
    final previousOtp = previousState.otp;
    final shouldValidate = previousOtp.invalid;
    final newOtp = shouldValidate ? Otp.dirty(newValue) : Otp.pure(newValue);
    final newState = previousState.copyWith(otp: newOtp);
    emit(newState);
  }

  Future<void> onSubmit() async {
    if (state.status.isLoading) return;

    final currentState = state;
    final otp = currentState.otp;
    if (otp.invalid) {
      emit(currentState.copyWith(status: OtpValidationStatus.invalidOtp));
      return;
    }

    emit(currentState.copyWith(status: OtpValidationStatus.loading));

    try {
      await _userRepository.verifyOtp(
        email: currentState.email.value,
        otp: otp.value,
      );
      emit(currentState.copyWith(status: OtpValidationStatus.success));
    } on Exception {
      emit(currentState.copyWith(status: OtpValidationStatus.failure));
    }
  }
}
