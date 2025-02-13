import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get counterAppBarTitle => 'Counter';

  @override
  String get backButtonLabel => 'Retour';

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
  String get newPasswordText => 'Nouveau mot de passe';

  @override
  String get otpText => 'Code de vérification';

  @override
  String get forgotPasswordButtonLabel => 'Mot de passe oublié ?';

  @override
  String get loginLabel => 'Connexion';

  @override
  String get loginButtonLabel => 'Connexion';

  @override
  String get signUpLabel => 'Inscription';

  @override
  String get signUpButtonLabel => 'Créer un compte';

  @override
  String get conditionsLabel =>
      'En vous connectant, vous acceptez de vous conformer à la Politique de confidentialité et aux Conditions générales d\'utilisation de Daïkoon.';

  @override
  String signInWithText(String provider) {
    return 'Connexion avec $provider';
  }

  @override
  String get usernameText => 'Pseudo';

  @override
  String get recoveryPasswordText => 'Récupération de mot de passe';

  @override
  String get changePasswordText => 'Changer le mot de passe';

  @override
  String get goBackConfirmationText =>
      'Êtes-vous sûr de vouloir revenir en arrière ?';

  @override
  String get loseAllEditsText =>
      'Vous perdrez toutes les modifications non enregistrées.';

  @override
  String get cancelText => 'Annuler';

  @override
  String get goBackText => 'Revenir en arrière';

  @override
  String get furtherText => 'Suite';

  @override
  String get forgotPasswordEmailConfirmationText =>
      'Vérification de l\'adresse e-mail';

  @override
  String verificationTokenSentText(String email) {
    return 'Token de vérification a été envoyé à $email';
  }

  @override
  String get homeNavBarItemLabel => 'Accueil';

  @override
  String get searchNavBarItemLabel => 'Recherche';

  @override
  String get favoriteNavBarItemLabel => 'Favoris';

  @override
  String get notificationNavBarItemLabel => 'Notifications';

  @override
  String get profileNavBarItemLabel => 'Profil';

  @override
  String get userProfileTileInformationLabel => 'Mes Informations';

  @override
  String get userProfileTileHistoricLabel => 'Historique';

  @override
  String get userProfileTileDaikoinsLabel => 'Mes Daïkoins';

  @override
  String get userProfileTileChangePasswordLabel => 'Changer le mot de passe';

  @override
  String get userProfileTileSettingsLabel => 'Paramètres';

  @override
  String get userProfileTileFriendsLabel => 'Mes Amis';

  @override
  String get userProfileTileLogoutLabel => 'Déconnexion';

  @override
  String get logOutText => 'Déconnexion';

  @override
  String get logOutConfirmationText =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get saveText => 'Sauvegarder';

  @override
  String get profileUpdatedTitle => 'Vos informations ont été mises à jour';

  @override
  String get test => 'Test';

  @override
  String drawerHeadline(String username) {
    return 'Hello $username ! 😁';
  }

  @override
  String get drawerWelcomeText =>
      'Bienvenue sur votre espace personnel Daïkoon ! \n Ici, vous pourrez retrouver tous vos défis, en créer de nouveaux et échanger avec vos amis ! 🔥';

  @override
  String get drawerListChallengeLabel => 'Mes défis';

  @override
  String get drawerChallengeLabel => 'Mes défis';

  @override
  String get drawerFriendsLabel => 'Mes amis';

  @override
  String get drawerMessagesLabel => 'Messagerie';

  @override
  String get drawerDaikoinsLabel => 'Mes Daïkoins';

  @override
  String get drawerSettingsLabel => 'Réglages';

  @override
  String get challengeCreationContinueButtonLabel => 'Continuer';

  @override
  String get challengeCreationCancelButtonLabel => 'Retour';

  @override
  String get challengeCreationTitleFormLabel => 'Nom du défi';

  @override
  String get challengeCreationTitleFormFieldHint => 'Défi fifa ⚽';

  @override
  String get challengeCreationQuestionFormLabel => 'Pronostics';

  @override
  String get challengeCreationQuestionFormFieldLabel => 'Votre question';

  @override
  String get challengeCreationQuestionFormFieldHint => 'Qui va gagner ?';
}
