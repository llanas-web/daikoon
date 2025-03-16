// ignore: unused_import
import 'package:intl/intl.dart' as intl;
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
  String get homeHeaderTitle =>
      'Pariez et défiez \nvos amis grâce \nà Daïkoon !';

  @override
  String get homeHeaderSubtitle =>
      'Défiez, pariez et gagnez ! Défiez vos amis, pariez sans montant ou avec des daïkoins. Dépensez vos daïkoins dans les points de ventes de nos partenaires agréés. 🔥🔥';

  @override
  String get homePartnersSeeAll => 'Tout voir >';

  @override
  String get homePartnersHonorTitle => 'A l\'honneur 🏆';

  @override
  String get homePartnersHonorSubtitle => 'Les points de vente';

  @override
  String get homePartnersListTitle => 'Nos partenaires 🥳';

  @override
  String get homePartnersListSubtitle => 'Tous nos partenaires à la une';

  @override
  String get homeOffersTitle => 'Offres spéciales 🤩';

  @override
  String get homeOffersSubtitle => 'Les offres du moment';

  @override
  String get homeSocialsTitle => 'Retrouvez nous sur nos réseaux sociaux 🫶';

  @override
  String get homeFooterLabel =>
      'Copyright © 2025 Daïkoon, Tout droits réservés.';

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
  String get drawerChallengeLabel => 'Défier';

  @override
  String get drawerListChallengeLabel => 'Mes défis';

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
  String get challengeCreationOptionsFormLabel => 'Pronostics';

  @override
  String get challengeCreationQuestionFormFieldLabel => 'Votre question';

  @override
  String get challengeCreationQuestionFormFieldHint => 'Qui va gagner ?';

  @override
  String get challengeCreationOptionsFormFieldLabel => 'Les choix';

  @override
  String get challengeCreationOptionsFormFieldHint => 'Choix 1';

  @override
  String get challengeCreationBetFormLabel => 'Choix du défi';

  @override
  String get challengeCreationBetFormFieldTrue => 'Daikoins';

  @override
  String get challengeCreationBetFormFieldFalse => 'Pas d\'enjeu';

  @override
  String get challengeCreationBetAmountFormLabel => 'Somme à parier';

  @override
  String get challengeCreationBetAmountMinFormFieldLabel => 'Minimum';

  @override
  String get challengeCreationBetAmountMaxFormFieldLabel => 'Maximum';

  @override
  String get challengeCreationBetAmountNoLimitFormFieldLabel => 'Pas de limite';

  @override
  String get challengeCreationParticipantsFormLabel => 'Les joueurs';

  @override
  String get challengeCreationParticipantsFormFieldLabel => 'Joueurs';

  @override
  String get challengeCreationParticipantsFormFieldHint => 'Pseudo';

  @override
  String get challengeCreationDatesFormLabel => 'Temporalité';

  @override
  String get challengeCreationDatesStartFieldLabel => 'Début du défi';

  @override
  String get challengeCreationDatesEndFieldLabel => 'Fin du défi';

  @override
  String get challengeCreationDatesLimitFieldLabel => 'Limite de mise';

  @override
  String get challengeCreationResumeLabel => 'Validation';

  @override
  String get challengeCreationSubmitButtonLabel => 'Valider';

  @override
  String get challengeCreationErrorTitle =>
      'Erreur lors de la création du défi : ';

  @override
  String get challengeDetailsQuestionLabel => 'Question du défi :';

  @override
  String challengeDetailsInvitationTitle(String challengeTitle) {
    return 'Vous invite à participer au défi \n $challengeTitle';
  }

  @override
  String challengeDetailsAcceptedCreatorTitle(String creatorUsername) {
    return 'Défi organisé par @$creatorUsername';
  }

  @override
  String challengeDetailsAcceptedTitle(String challengeTitle) {
    return 'Participer au défi \n $challengeTitle';
  }

  @override
  String get challengeDetailsAcceptedChoiceLabel => 'Votre choix :';

  @override
  String get challengeDetailsAcceptedDaikoinsLabel => 'Choix des Daïkoins';

  @override
  String get challengeDetailsLimitDateLabel => 'Date de fin de mise';

  @override
  String get challengeDetailsStartDateLabel => 'Début du défi';

  @override
  String get challengeDetailsEndDateLabel => 'Fin du défi';

  @override
  String get challengeDetailsAcceptedValidateButtonLabel => 'Valider';

  @override
  String get challengeDetailsPendingAcceptTimeLeftButtonLabel =>
      'Temps restant';

  @override
  String get challengeDetailsPendingListParticipantLabel =>
      'Joueurs participants';

  @override
  String get challengeDetailsPendingParticipateButtonLabel => 'Je participe';

  @override
  String get challengeDetailsPendingRefuseButtonLabel => 'Non merci!';

  @override
  String challengeDetailsStatsCreatorTitle(String creatorUsername) {
    return 'Défi organisé par @$creatorUsername';
  }

  @override
  String challengeDetailsStatsTitle(String challengeTitle) {
    return 'Statistiques du défi \n $challengeTitle';
  }

  @override
  String get challengeDetailsStatsButtonLabel => 'Désigner un gagnant';

  @override
  String challengeDetailsFinishTitle(String challengeTitle) {
    return 'Fin du défi ! \n $challengeTitle';
  }

  @override
  String get challengeDetailsFinishChoiceLabel =>
      'Selection de la bonne réponse';

  @override
  String get challengeDetailsFinishWinnerLabel =>
      'Le(s) gagnant(s) séléctionné(s)';

  @override
  String get challengeDetailsFinishButtonLabel => 'Valider';

  @override
  String get challengeDetailsEndedWonTitle =>
      'Félicitations \n Vous avez gagné ! 🏅';

  @override
  String get challengeDetailsEndedLoseTitle =>
      'Dommage... \n Vous avez perdu ! 😢';

  @override
  String get challengeDetailsEndedWinnersLabel => 'Le(s) gagnant(s)';

  @override
  String get challengeDetailsEndedDaikoinsWinLabel => 'Vous avez gagné';
}
