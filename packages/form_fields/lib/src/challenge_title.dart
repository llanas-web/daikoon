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
        ChallengeTitleError.empty: 'Le titre du défi ne peut pas être vide',
        ChallengeTitleError.invalid:
            // ignore: lines_longer_than_80_chars
            "Le titre du défi doit contenir au moins 3 caractères et n'utiliser que des lettres, chiffres, espaces, tirets et underscores",
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
