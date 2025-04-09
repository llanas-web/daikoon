import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('fr')];

  /// Text shown in the AppBar of the Counter Page
  ///
  /// In fr, this message translates to:
  /// **'Counter'**
  String get counterAppBarTitle;

  /// Label text for the back button
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get backButtonLabel;

  /// Label text for the required field
  ///
  /// In fr, this message translates to:
  /// **'champs obligatoires'**
  String get requiredFieldLabel;

  /// Hint text for the email text field
  ///
  /// In fr, this message translates to:
  /// **'Saisissez votre adresse e-mail'**
  String get emailTextFieldHint;

  /// Label text for the email text field
  ///
  /// In fr, this message translates to:
  /// **'Adresse e-mail'**
  String get emailTextFieldLabel;

  /// Hint text for the password text field
  ///
  /// In fr, this message translates to:
  /// **'Saisissez votre mot de passe'**
  String get passwordTextFieldHint;

  /// Label text for the password text field
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get passwordTextFieldLabel;

  /// Text shown before the new password text field
  ///
  /// In fr, this message translates to:
  /// **'Nouveau mot de passe'**
  String get newPasswordText;

  /// Text shown before the otp text field
  ///
  /// In fr, this message translates to:
  /// **'Code de vérification'**
  String get otpText;

  /// Label text for the forgot password button
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get forgotPasswordButtonLabel;

  /// Label text for the connexion
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get loginLabel;

  /// Label text for the connexion button
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get loginButtonLabel;

  /// Label text for the inscription
  ///
  /// In fr, this message translates to:
  /// **'Inscription'**
  String get signUpLabel;

  /// Label text for the inscription button
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get signUpButtonLabel;

  /// Label text for the inscription otp validation
  ///
  /// In fr, this message translates to:
  /// **'Vérification de l\'\'adresse e-mail'**
  String get signUpOtpValidationLabel;

  /// Label text for the inscription otp validation button
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get signUpOtpValidationButtonLabel;

  /// Label text for the conditions
  ///
  /// In fr, this message translates to:
  /// **'En vous connectant, vous acceptez de vous conformer à la Politique de confidentialité et aux Conditions générales d\'\'utilisation de Daïkoon.'**
  String get conditionsLabel;

  /// Text shown before the social media buttons
  ///
  /// In fr, this message translates to:
  /// **'Connexion avec {provider}'**
  String signInWithText(String provider);

  /// Text shown before the username text field
  ///
  /// In fr, this message translates to:
  /// **'Pseudo'**
  String get usernameText;

  /// Text shown in the recovery password page
  ///
  /// In fr, this message translates to:
  /// **'Récupération de mot de passe'**
  String get recoveryPasswordText;

  /// Text shown in the change password page
  ///
  /// In fr, this message translates to:
  /// **'Changer le mot de passe'**
  String get changePasswordText;

  /// Text shown in the confirmation dialog when the user tries to go back
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir revenir en arrière ?'**
  String get goBackConfirmationText;

  /// Text shown in the confirmation dialog when the user tries to go back
  ///
  /// In fr, this message translates to:
  /// **'Vous perdrez toutes les modifications non enregistrées.'**
  String get loseAllEditsText;

  /// Text shown in the confirmation dialog when the user tries to go back
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancelText;

  /// Text shown in the confirmation dialog when the user tries to go back
  ///
  /// In fr, this message translates to:
  /// **'Revenir en arrière'**
  String get goBackText;

  /// Text shown in the confirmation dialog when the user tries to go back
  ///
  /// In fr, this message translates to:
  /// **'Suite'**
  String get furtherText;

  /// Text shown in the forgot password page
  ///
  /// In fr, this message translates to:
  /// **'Vérification de l\'\'adresse e-mail'**
  String get forgotPasswordEmailConfirmationText;

  /// No description provided for @verificationTokenSentText.
  ///
  /// In fr, this message translates to:
  /// **'Token de vérification a été envoyé à {email}'**
  String verificationTokenSentText(String email);

  /// Label text for the home nav bar item
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get homeNavBarItemLabel;

  /// Label text for the search nav bar item
  ///
  /// In fr, this message translates to:
  /// **'Recherche'**
  String get searchNavBarItemLabel;

  /// Label text for the favorite nav bar item
  ///
  /// In fr, this message translates to:
  /// **'Favoris'**
  String get favoriteNavBarItemLabel;

  /// Label text for the notification nav bar item
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get notificationNavBarItemLabel;

  /// Label text for the profile nav bar item
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get profileNavBarItemLabel;

  /// Title text for the home header
  ///
  /// In fr, this message translates to:
  /// **'Pariez et défiez \nvos amis grâce \nà Daïkoon !'**
  String get homeHeaderTitle;

  /// Subtitle text for the home header
  ///
  /// In fr, this message translates to:
  /// **'Défiez, pariez et gagnez ! Défiez vos amis, pariez sans montant ou avec des daïkoins. Dépensez vos daïkoins dans les points de ventes de nos partenaires agréés. 🔥🔥'**
  String get homeHeaderSubtitle;

  /// Text for the see all button in the home partenaires
  ///
  /// In fr, this message translates to:
  /// **'Tout voir >'**
  String get homePartnersSeeAll;

  /// Title text for the home partenaires honor
  ///
  /// In fr, this message translates to:
  /// **'A l\'\'honneur 🏆'**
  String get homePartnersHonorTitle;

  /// Subtitle text for the home partenaires honor
  ///
  /// In fr, this message translates to:
  /// **'Les points de vente'**
  String get homePartnersHonorSubtitle;

  /// Title text for the home partenaires list
  ///
  /// In fr, this message translates to:
  /// **'Nos partenaires 🥳'**
  String get homePartnersListTitle;

  /// Subtitle text for the home partenaires list
  ///
  /// In fr, this message translates to:
  /// **'Tous nos partenaires à la une'**
  String get homePartnersListSubtitle;

  /// Title text for the home offers
  ///
  /// In fr, this message translates to:
  /// **'Offres spéciales 🤩'**
  String get homeOffersTitle;

  /// Subtitle text for the home offers
  ///
  /// In fr, this message translates to:
  /// **'Les offres du moment'**
  String get homeOffersSubtitle;

  /// Title text for the home socials
  ///
  /// In fr, this message translates to:
  /// **'Retrouvez nous sur nos réseaux sociaux 🫶'**
  String get homeSocialsTitle;

  /// Label text for the home footer
  ///
  /// In fr, this message translates to:
  /// **'Copyright © 2025 Daïkoon, Tout droits réservés.'**
  String get homeFooterLabel;

  /// Label text for the information tile
  ///
  /// In fr, this message translates to:
  /// **'Mes Informations'**
  String get userProfileTileInformationLabel;

  /// Label text for the historic tile
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get userProfileTileHistoricLabel;

  /// Label text for the daikoins tile
  ///
  /// In fr, this message translates to:
  /// **'Mes Daïkoins'**
  String get userProfileTileDaikoinsLabel;

  /// Label text for the change password tile
  ///
  /// In fr, this message translates to:
  /// **'Changer le mot de passe'**
  String get userProfileTileChangePasswordLabel;

  /// Label text for the settings tile
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get userProfileTileSettingsLabel;

  /// Label text for the friends tile
  ///
  /// In fr, this message translates to:
  /// **'Mes Amis'**
  String get userProfileTileFriendsLabel;

  /// Label text for the logout tile
  ///
  /// In fr, this message translates to:
  /// **'Déconnexion'**
  String get userProfileTileLogoutLabel;

  /// Text shown in the logout page
  ///
  /// In fr, this message translates to:
  /// **'Déconnexion'**
  String get logOutText;

  /// Text shown in the confirmation dialog when the user tries to logout
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir vous déconnecter ?'**
  String get logOutConfirmationText;

  /// Text shown in the save button
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarder'**
  String get saveText;

  /// Title text for the profile updated page
  ///
  /// In fr, this message translates to:
  /// **'Vos informations ont été mises à jour'**
  String get profileUpdatedTitle;

  /// Test
  ///
  /// In fr, this message translates to:
  /// **'Test'**
  String get test;

  /// Header of the drawer with the username of connected user
  ///
  /// In fr, this message translates to:
  /// **'Hello {username} ! 😁'**
  String drawerHeadline(String username);

  /// Welcome text explaining daikoon in the drawer header
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue sur votre espace personnel Daïkoon ! \n Ici, vous pourrez retrouver tous vos défis, en créer de nouveaux et échanger avec vos amis ! 🔥'**
  String get drawerWelcomeText;

  /// Label for the challenges page
  ///
  /// In fr, this message translates to:
  /// **'Défier'**
  String get drawerChallengeLabel;

  /// Label for the list challenges page
  ///
  /// In fr, this message translates to:
  /// **'Mes défis'**
  String get drawerListChallengeLabel;

  /// Label for the friends page
  ///
  /// In fr, this message translates to:
  /// **'Mes amis'**
  String get drawerFriendsLabel;

  /// Label for the messages page
  ///
  /// In fr, this message translates to:
  /// **'Messagerie'**
  String get drawerMessagesLabel;

  /// Label for the daikoins page
  ///
  /// In fr, this message translates to:
  /// **'Mes Daïkoins'**
  String get drawerDaikoinsLabel;

  /// Label for the settings page
  ///
  /// In fr, this message translates to:
  /// **'Réglages'**
  String get drawerSettingsLabel;

  /// Label for the continue button in the challenge creation page
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get challengeCreationContinueButtonLabel;

  /// Label for the cancel button in the challenge creation page
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get challengeCreationCancelButtonLabel;

  /// Label for the title form in the challenge creation page
  ///
  /// In fr, this message translates to:
  /// **'Nom du défi'**
  String get challengeCreationTitleFormLabel;

  /// Hint text for the title form field in the challenge creation page
  ///
  /// In fr, this message translates to:
  /// **'Défi fifa ⚽'**
  String get challengeCreationTitleFormFieldHint;

  /// Error message for the title form field in the challenge creation page
  ///
  /// In fr, this message translates to:
  /// **'Le titre du défi ne peut pas être vide'**
  String get challengeCreationTitleFormFieldErrorEmpty;

  /// Error message for the title form field in the challenge creation page
  ///
  /// In fr, this message translates to:
  /// **'Le titre du défi doit contenir au moins 3 caractères et n\'\'utiliser que des lettres, chiffres, espaces, tirets et underscores'**
  String get challengeCreationTitleFormFieldErrorDescription;

  /// Label for the question form in the challenge creation page
  ///
  /// In fr, this message translates to:
  /// **'Pronostics'**
  String get challengeCreationOptionsFormLabel;

  /// Label for the question form field in the challenge creation page
  ///
  /// In fr, this message translates to:
  /// **'Votre question'**
  String get challengeCreationQuestionFormFieldLabel;

  /// Hint text for the question form field in the challenge creation page
  ///
  /// In fr, this message translates to:
  /// **'Qui va gagner ?'**
  String get challengeCreationQuestionFormFieldHint;

  /// Error message for the question form field in the challenge creation page
  ///
  /// In fr, this message translates to:
  /// **'La question ne peut pas être vide'**
  String get challengeCreationQuestionFormFieldErrorEmtpy;

  /// Error message for the question form field in the challenge creation page
  ///
  /// In fr, this message translates to:
  /// **'La question doit contenir au moins 4 caractères'**
  String get challengeCreationQuestionFormFieldErrorInvalid;

  /// Label for the option form in the challenge creation page
  ///
  /// In fr, this message translates to:
  /// **'Les choix'**
  String get challengeCreationOptionsFormFieldLabel;

  /// Hint text for the option form field in the challenge creation page
  ///
  /// In fr, this message translates to:
  /// **'Choix 1'**
  String get challengeCreationOptionsFormFieldHint;

  /// Label for the daikoins choice form in the challenge creation page
  ///
  /// In fr, this message translates to:
  /// **'Choix du défi'**
  String get challengeCreationBetFormLabel;

  /// Text for the daikoins choice in the challenge creation page
  ///
  /// In fr, this message translates to:
  /// **'Daikoins'**
  String get challengeCreationBetFormFieldTrue;

  /// Text for the daikoins choice in the challenge creation page
  ///
  /// In fr, this message translates to:
  /// **'Pas d\'\'enjeu'**
  String get challengeCreationBetFormFieldFalse;

  /// Label for the amount form in the challenge creation page
  ///
  /// In fr, this message translates to:
  /// **'Somme à parier'**
  String get challengeCreationBetAmountFormLabel;

  /// Label for the minimum amount form field in the challenge creation page
  ///
  /// In fr, this message translates to:
  /// **'Minimum'**
  String get challengeCreationBetAmountMinFormFieldLabel;

  /// Label for the maximum amount form field in the challenge creation page
  ///
  /// In fr, this message translates to:
  /// **'Maximum'**
  String get challengeCreationBetAmountMaxFormFieldLabel;

  /// Label for the no limit amount form field in the challenge creation page
  ///
  /// In fr, this message translates to:
  /// **'Pas de limite'**
  String get challengeCreationBetAmountNoLimitFormFieldLabel;

  /// Label for the participants form in the challenge creation page
  ///
  /// In fr, this message translates to:
  /// **'Les joueurs'**
  String get challengeCreationParticipantsFormLabel;

  /// Label for the participants form field in the challenge creation page
  ///
  /// In fr, this message translates to:
  /// **'Joueurs : '**
  String get challengeCreationParticipantsFormFieldLabel;

  /// Hint text for the participants form field in the challenge creation page
  ///
  /// In fr, this message translates to:
  /// **'Pseudo'**
  String get challengeCreationParticipantsFormFieldHint;

  /// Label for the dates form in the challenge creation page
  ///
  /// In fr, this message translates to:
  /// **'Temporalité'**
  String get challengeCreationDatesFormLabel;

  /// Label for the start date form field in the challenge creation page
  ///
  /// In fr, this message translates to:
  /// **'Début du défi'**
  String get challengeCreationDatesStartFieldLabel;

  /// Label for the end date form field in the challenge creation page
  ///
  /// In fr, this message translates to:
  /// **'Fin du défi'**
  String get challengeCreationDatesEndFieldLabel;

  /// Label for the limit date form field in the challenge creation page
  ///
  /// In fr, this message translates to:
  /// **'Limite de mise'**
  String get challengeCreationDatesLimitFieldLabel;

  /// Label for the resume page in the challenge creation page
  ///
  /// In fr, this message translates to:
  /// **'Validation'**
  String get challengeCreationResumeLabel;

  /// Label for the submit button in the challenge creation page
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get challengeCreationSubmitButtonLabel;

  /// Title for the error dialog in the challenge creation page
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la création du défi : '**
  String get challengeCreationErrorTitle;

  /// Label for the question in the challenge details page
  ///
  /// In fr, this message translates to:
  /// **'Question du défi :'**
  String get challengeDetailsQuestionLabel;

  /// Header of the drawer with the username of connected user
  ///
  /// In fr, this message translates to:
  /// **'Vous invite à participer au défi \n {challengeTitle}'**
  String challengeDetailsInvitationTitle(String challengeTitle);

  /// Header of the drawer with the username of connected user
  ///
  /// In fr, this message translates to:
  /// **'Défi organisé par @{creatorUsername}'**
  String challengeDetailsAcceptedCreatorTitle(String creatorUsername);

  /// Header of the drawer with the username of connected user
  ///
  /// In fr, this message translates to:
  /// **'Participer au défi \n {challengeTitle}'**
  String challengeDetailsAcceptedTitle(String challengeTitle);

  /// Label for the choice in the challenge details page
  ///
  /// In fr, this message translates to:
  /// **'Votre choix :'**
  String get challengeDetailsAcceptedChoiceLabel;

  /// Label for the daikoins choice in the challenge details page
  ///
  /// In fr, this message translates to:
  /// **'Choix des Daïkoins'**
  String get challengeDetailsAcceptedDaikoinsLabel;

  /// Error message for the daikoins amount in the challenge details page
  ///
  /// In fr, this message translates to:
  /// **'Solde insuffisant'**
  String get challengeDetailsAcceptedDaikoinsAmountErrorWallet;

  /// Error message for the daikoins amount in the challenge details page
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'\'avez que \${amount} Daïkoins dans votre portefeuille'**
  String challengeDetailsAcceptedDaikoinsAmountErrorWalletDescription(
      String amount);

  /// Error message for the daikoins amount in the challenge details page
  ///
  /// In fr, this message translates to:
  /// **'Mise insuffisante'**
  String get challengeDetailsAcceptedDaikoinsAmountErrorMinBet;

  /// Error message for the daikoins amount in the challenge details page
  ///
  /// In fr, this message translates to:
  /// **'Vous devez miser au moins \${amount} Daïkoins'**
  String challengeDetailsAcceptedDaikoinsAmountErrorBetMinDescription(
      String amount);

  /// Error message for the daikoins amount in the challenge details page
  ///
  /// In fr, this message translates to:
  /// **'Mise trop élevée'**
  String get challengeDetailsAcceptedDaikoinsAmountErrorMaxBet;

  /// Error message for the daikoins amount in the challenge details page
  ///
  /// In fr, this message translates to:
  /// **'Vous ne pouvez pas miser plus de \${amount} Daïkoins'**
  String challengeDetailsAcceptedDaikoinsAmountErrorBetMaxDescription(
      String amount);

  /// Label for the pending transaction button in the challenge details page
  ///
  /// In fr, this message translates to:
  /// **'En attente de connexion pour validation du pari'**
  String get challengeDetailsAcceptedTransactionPendingLabel;

  /// Label for the limit date in the challenge details page
  ///
  /// In fr, this message translates to:
  /// **'Date de fin de mise'**
  String get challengeDetailsLimitDateLabel;

  /// Label for the start date in the challenge details page
  ///
  /// In fr, this message translates to:
  /// **'Début du défi'**
  String get challengeDetailsStartDateLabel;

  /// Label for the end date in the challenge details page
  ///
  /// In fr, this message translates to:
  /// **'Fin du défi'**
  String get challengeDetailsEndDateLabel;

  /// Label for the validate button in the challenge details page
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get challengeDetailsAcceptedValidateButtonLabel;

  /// Label for the time left button in the challenge details page
  ///
  /// In fr, this message translates to:
  /// **'Temps restant'**
  String get challengeDetailsPendingAcceptTimeLeftButtonLabel;

  /// Label for the list of participants in the challenge details page
  ///
  /// In fr, this message translates to:
  /// **'Joueurs participants'**
  String get challengeDetailsPendingListParticipantLabel;

  /// Label for the participate button in the challenge details page
  ///
  /// In fr, this message translates to:
  /// **'Je participe'**
  String get challengeDetailsPendingParticipateButtonLabel;

  /// Label for the refuse button in the challenge details page
  ///
  /// In fr, this message translates to:
  /// **'Non merci!'**
  String get challengeDetailsPendingRefuseButtonLabel;

  /// Header of the drawer with the username of connected user
  ///
  /// In fr, this message translates to:
  /// **'Défi organisé par @{creatorUsername}'**
  String challengeDetailsStatsCreatorTitle(String creatorUsername);

  /// Header of the drawer with the username of connected user
  ///
  /// In fr, this message translates to:
  /// **'Statistiques du défi \n {challengeTitle}'**
  String challengeDetailsStatsTitle(String challengeTitle);

  /// Label for the stats button in the challenge details page
  ///
  /// In fr, this message translates to:
  /// **'Désigner un gagnant'**
  String get challengeDetailsStatsButtonLabel;

  /// Header of the drawer with the username of connected user
  ///
  /// In fr, this message translates to:
  /// **'Fin du défi ! \n {challengeTitle}'**
  String challengeDetailsFinishTitle(String challengeTitle);

  /// Label for the choice in the challenge details page
  ///
  /// In fr, this message translates to:
  /// **'Selection de la bonne réponse'**
  String get challengeDetailsFinishChoiceLabel;

  /// Label for the winner in the challenge details page
  ///
  /// In fr, this message translates to:
  /// **'Le(s) gagnant(s) séléctionné(s)'**
  String get challengeDetailsFinishWinnerLabel;

  /// Label for the validate button in the challenge details page
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get challengeDetailsFinishButtonLabel;

  /// Header of the drawer with the username of connected user
  ///
  /// In fr, this message translates to:
  /// **'Félicitations \n Vous avez gagné ! 🏅'**
  String get challengeDetailsEndedWonTitle;

  /// Header of the drawer with the username of connected user
  ///
  /// In fr, this message translates to:
  /// **'Dommage... \n Vous avez perdu ! 👎'**
  String get challengeDetailsEndedLoseTitle;

  /// Label for the winners in the challenge details page
  ///
  /// In fr, this message translates to:
  /// **'Le(s) gagnant(s)'**
  String get challengeDetailsEndedWinnersLabel;

  /// Label for the daikoins win in the challenge details page
  ///
  /// In fr, this message translates to:
  /// **'Vous avez gagné'**
  String get challengeDetailsEndedDaikoinsWinLabel;

  /// Label for the no winners in the challenge details page
  ///
  /// In fr, this message translates to:
  /// **'Pas de gagnant'**
  String get challengeDetailsEndedNoWinnersLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
