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

  /// Text shown in the drawer
  ///
  /// In fr, this message translates to:
  /// **'Hello {username} ! 😁'**
  String drawerHeadline(String username);

  /// Text shown in the drawer
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue sur votre espace personnel Daïkoon ! \n Ici, vous pourrez retrouver tous vos défis, en créer de nouveaux et échanger avec vos amis ! 🔥'**
  String get drawerWelcomeText;

  /// Text shown in the drawer
  ///
  /// In fr, this message translates to:
  /// **'Mes défis'**
  String get drawerListChallengeTitle;
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
