import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:form_fields/form_fields.dart';
import 'package:formz/formz.dart';

/// {@template challenge_title}
/// Formz input for challenge title. It can be empty or invalid.
/// {@endtemplate}
@immutable
class ChallengeQuestion extends FormzInput<String, ChallengeQuestionError>
    with EquatableMixin, FormzValidationMixin {
  /// {@macro email.pure}
  const ChallengeQuestion.pure([super.value = '']) : super.pure();

  /// {@macro email.dirty}
  const ChallengeQuestion.dirty(super.value) : super.dirty();

  static final _challengeTitleRegex = RegExp(r'^[a-zA-Z0-9_.]{6,32}$');

  @override
  ChallengeQuestionError? validator(String value) {
    if (value.isEmpty) return ChallengeQuestionError.empty;
    if (!_challengeTitleRegex.hasMatch(value)) {
      return ChallengeQuestionError.invalid;
    }
    return null;
  }

  @override
  Map<ChallengeQuestionError?, String?> get validationErrorMessage => {
        ChallengeQuestionError.empty: 'This field is required',
        ChallengeQuestionError.invalid: '''
              Challenge title must be between 6 and 32 characters. 
              Also, it can only contain letters, numbers, periods, and underscores.
            ''',
        null: null,
      };

  @override
  List<Object> get props => [pure, value];
}

/// Validation errors for [Email]. It can be empty, invalid or already
/// registered.
enum ChallengeQuestionError {
  /// Empty email.
  empty,

  /// Invalid email.
  invalid,
}
