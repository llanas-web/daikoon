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

// Add space to the regex
  static final _challengeTitleRegex = RegExp(r'^[a-zA-Z0-9_.?\s]{6,32}$');

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
        ChallengeQuestionError.empty: 'La question ne peut pas être vide',
        ChallengeQuestionError.invalid:
            'La question doit contenir au moins 6 caractères',
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
