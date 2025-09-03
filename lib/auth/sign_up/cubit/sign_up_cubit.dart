import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:form_fields/form_fields.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:powersync_repository/powersync_repository.dart';
import 'package:shared/shared.dart';
import 'package:supabase_authentication_client/supabase_authentication_client.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_up_state.dart';

/// {@template sign_up_cubit}
/// Cubit for sign up state management. It is used to change signup state from
/// initial to in progress, success or error. It also validates email, password,
/// name, surname and phone number fields.
/// {@endtemplate}
class SignUpCubit extends Cubit<SignUpState> {
  /// {@macro sign_up_cubit}
  SignUpCubit({
    required UserRepository userRepository,
    required NotificationsRepository notificationsRepository,
  })  : _userRepository = userRepository,
        _notificationsRepository = notificationsRepository,
        super(const SignUpState.initial());

  final UserRepository _userRepository;
  final NotificationsRepository _notificationsRepository;

  /// Changes password visibility, making it visible or not.
  void changePasswordVisibility() => emit(
        state.copyWith(showPassword: !state.showPassword),
      );

  /// Emits initial state of signup screen. It is used to reset state.
  void resetState() => emit(const SignUpState.initial());

  /// [Email] value was changed, triggering new changes in state. Checking
  /// whether or not value is valid in [Email] and emmiting new [Email]
  /// validation state.
  void onEmailChanged(String newValue) {
    final previousScreenState = state;
    final previousEmailState = previousScreenState.email;
    final shouldValidate = previousEmailState.isNotValid;
    final newEmailState = shouldValidate
        ? Email.dirty(
            newValue,
          )
        : Email.pure(
            newValue,
          );

    final newScreenState = state.copyWith(
      email: newEmailState,
    );

    emit(newScreenState);
  }

  /// [Email] field was unfocused, here is checking if previous state
  /// with [Email] was valid, in order to indicate it in state after unfocus.
  void onEmailUnfocused() {
    final previousScreenState = state;
    final previousEmailState = previousScreenState.email;
    final previousEmailValue = previousEmailState.value;

    final newEmailState = Email.dirty(
      previousEmailValue,
    );
    final newScreenState = previousScreenState.copyWith(
      email: newEmailState,
    );
    emit(newScreenState);
  }

  /// [Password] value was changed, triggering new changes in state. Checking
  /// whether or not value is valid in [Password] and emmiting new [Password]
  /// validation state.
  void onPasswordChanged(String newValue) {
    final previousScreenState = state;
    final previousPasswordState = previousScreenState.password;
    final shouldValidate = previousPasswordState.isNotValid;
    final newPasswordState = shouldValidate
        ? Password.dirty(
            newValue,
          )
        : Password.pure(
            newValue,
          );

    final newScreenState = state.copyWith(
      password: newPasswordState,
    );

    emit(newScreenState);
  }

  void onPasswordUnfocused() {
    final previousScreenState = state;
    final previousPasswordState = previousScreenState.password;
    final previousPasswordValue = previousPasswordState.value;

    final newPasswordState = Password.dirty(
      previousPasswordValue,
    );
    final newScreenState = previousScreenState.copyWith(
      password: newPasswordState,
    );
    emit(newScreenState);
  }

  /// [Username] value was changed, triggering new changes in state. Checking
  /// whether or not value is valid in [Username] and emmiting new [Username]
  /// validation state.
  void onUsernameChanged(String newValue) {
    final previousScreenState = state;
    final previousUsernameState = previousScreenState.username;
    final shouldValidate = previousUsernameState.isNotValid;
    final newSurnameState = shouldValidate
        ? Username.dirty(
            newValue,
          )
        : Username.pure(
            newValue,
          );

    final newScreenState = state.copyWith(
      username: newSurnameState,
    );

    emit(newScreenState);
  }

  void onUsernameUnfocused() {
    final previousScreenState = state;
    final previousUsernameState = previousScreenState.username;
    final previousUsernameValue = previousUsernameState.value;

    final newUsernameState = Username.dirty(
      previousUsernameValue,
    );
    final newScreenState = previousScreenState.copyWith(
      username: newUsernameState,
    );
    emit(newScreenState);
  }

  /// Defines method to submit form. It is used to check if all inputs are valid
  /// and if so, it is used to signup user.
  Future<void> onSubmit({
    VoidCallback? onSuccess,
  }) async {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final username = Username.dirty(state.username.value);
    final isFormValid = FormzValid([email, password, username]).isFormValid;

    final newState = state.copyWith(
      email: email,
      password: password,
      username: username,
      submissionStatus: isFormValid ? SignUpSubmissionStatus.inProgress : null,
    );

    emit(newState);

    if (!isFormValid) return;

    try {
      final pushToken = await _notificationsRepository.fetchToken();

      await _userRepository.signUpWithPassword(
        email: email.value,
        password: password.value,
        username: username.value,
        pushToken: pushToken,
      );

      if (isClosed) return;
      emit(state.copyWith(submissionStatus: SignUpSubmissionStatus.success));
      onSuccess?.call();
    } catch (e, stackTrace) {
      _errorFormatter(e, stackTrace);
    }
  }

  Future<void> loginWithGoogle() async {
    emit(
      state.copyWith(
        submissionStatus: SignUpSubmissionStatus.googleAuthInProgress,
      ),
    );
    try {
      await _userRepository.logInWithGoogle();
      emit(state.copyWith(submissionStatus: SignUpSubmissionStatus.success));
    } on LogInWithGoogleCanceled {
      emit(state.copyWith(submissionStatus: SignUpSubmissionStatus.idle));
    } catch (error, stackTrace) {
      _errorFormatter(error, stackTrace);
    }
  }

  Future<void> loginWithApple() async {
    emit(
      state.copyWith(
        submissionStatus: SignUpSubmissionStatus.appleAuthInProgress,
      ),
    );
    try {
      await _userRepository.logInWithApple();
      emit(state.copyWith(submissionStatus: SignUpSubmissionStatus.success));
    } on LogInWithAppleCanceled {
      emit(state.copyWith(submissionStatus: SignUpSubmissionStatus.idle));
    } catch (error, stackTrace) {
      _errorFormatter(error, stackTrace);
    }
  }

  /// Defines method to format error. It is used to format error in order to
  /// show it to user.
  void _errorFormatter(Object e, StackTrace stackTrace) {
    addError(e, stackTrace);

    final submissionStatus = switch (e) {
      SignUpWithPasswordFailure(:final AuthException error) => switch (
            error.statusCode?.parse) {
          HttpStatus.unprocessableEntity =>
            SignUpSubmissionStatus.emailAlreadyRegistered,
          _ => SignUpSubmissionStatus.error,
        },
      _ => SignUpSubmissionStatus.idle,
    };

    final newState = state.copyWith(
      submissionStatus: submissionStatus,
    );
    emit(newState);
  }
}
