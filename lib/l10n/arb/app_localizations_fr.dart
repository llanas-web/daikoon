import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get counterAppBarTitle => 'Counter';

  @override
  String get requiredFieldLabel => 'champs obligatoires';

  @override
  String get emailTextFieldHint => 'Saisissez votre adresse e-mail';

  @override
  String get emailTextFieldLabel => 'Adresse e-mail';

  @override
  String get passwordTextFieldHint => 'Saisissez votre mot de passe';

  @override
  String get passwordTextFieldLabel => 'Mot de passe';

  @override
  String get forgotPasswordButtonLabel => 'Mot de passe oublié ?';

  @override
  String get connexionButtonLabel => 'Connexion';

  @override
  String get conditionsLabel => 'En vous connectant, vous acceptez de vous conformer à la Politique de confidentialité et aux Conditions générales d\'utilisation de Daïkoon.';
}
