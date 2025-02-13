import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:form_fields/form_fields.dart';
import 'package:formz/formz.dart';

/// {@template challenge_title}
/// Formz input for challenge title. It can be empty or invalid.
/// {@endtemplate}
@immutable
class ChallengeTitle extends FormzInput<String, ChallengeTitleError>
    with EquatableMixin, FormzValidationMixin {
  /// {@macro email.pure}
  const ChallengeTitle.pure([super.value = '']) : super.pure();

  /// {@macro email.dirty}
  const ChallengeTitle.dirty(super.value) : super.dirty();

  static final _challengeTitleRegex = RegExp(r'^[a-zA-Z0-9_.]{3,16}$');

  @override
  ChallengeTitleError? validator(String value) {
    if (value.isEmpty) return ChallengeTitleError.empty;
    if (!_challengeTitleRegex.hasMatch(value)) {
      return ChallengeTitleError.invalid;
    }
    return null;
  }

  @override
  Map<ChallengeTitleError?, String?> get validationErrorMessage => {
        ChallengeTitleError.empty: 'This field is required',
        ChallengeTitleError.invalid: '''
              Challenge title must be between 3 and 16 characters. 
              Also, it can only contain letters, numbers, periods, and underscores.
            ''',
        null: null,
      };

  @override
  List<Object> get props => [pure, value];
}

/// Validation errors for [Email]. It can be empty, invalid or already
/// registered.
enum ChallengeTitleError {
  /// Empty email.
  empty,

  /// Invalid email.
  invalid,
}
