import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
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
/// import 'l10n/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @helloWorld.
  ///
  /// In en, this message translates to:
  /// **'Hello World'**
  String get helloWorld;

  /// No description provided for @admin_button.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin_button;

  /// No description provided for @guest_button.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest_button;

  /// No description provided for @login_button.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_button;

  /// No description provided for @admin_login_title.
  ///
  /// In en, this message translates to:
  /// **'Login to your admin account'**
  String get admin_login_title;

  /// No description provided for @email_hint.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email_hint;

  /// No description provided for @password_hint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password_hint;

  /// No description provided for @create_your_password.
  ///
  /// In en, this message translates to:
  /// **'Create you password'**
  String get create_your_password;

  /// No description provided for @name_hint.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get name_hint;

  /// No description provided for @pick_nationality.
  ///
  /// In en, this message translates to:
  /// **'Pick Nationality'**
  String get pick_nationality;

  /// No description provided for @phone_hint.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_hint;

  /// No description provided for @form_validate_full_name.
  ///
  /// In en, this message translates to:
  /// **'Full name can\'t be empty'**
  String get form_validate_full_name;

  /// No description provided for @form_validate_email.
  ///
  /// In en, this message translates to:
  /// **'Email can\'t be empty'**
  String get form_validate_email;

  /// No description provided for @form_validate_password.
  ///
  /// In en, this message translates to:
  /// **'Password can\'t be empty'**
  String get form_validate_password;

  /// No description provided for @form_validate_phone.
  ///
  /// In en, this message translates to:
  /// **'Phone number can\'t be empty'**
  String get form_validate_phone;

  /// No description provided for @form_validate_nationality.
  ///
  /// In en, this message translates to:
  /// **'Please select your nationality'**
  String get form_validate_nationality;

  /// No description provided for @form_validate.
  ///
  /// In en, this message translates to:
  /// **'Please fill all the fields'**
  String get form_validate;

  /// No description provided for @please_confirm_your_password.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get please_confirm_your_password;

  /// No description provided for @delete_my_account.
  ///
  /// In en, this message translates to:
  /// **'Delete My Account'**
  String get delete_my_account;

  /// No description provided for @alert_notif_title.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get alert_notif_title;

  /// No description provided for @alert_notif_msg.
  ///
  /// In en, this message translates to:
  /// **'a missing person was reported'**
  String get alert_notif_msg;

  /// No description provided for @hi.
  ///
  /// In en, this message translates to:
  /// **'Hi'**
  String get hi;

  /// No description provided for @welcome_message.
  ///
  /// In en, this message translates to:
  /// **'What do you want to do today?'**
  String get welcome_message;

  /// No description provided for @report_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to report a missing person?'**
  String get report_confirmation;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @cant_find_hadj.
  ///
  /// In en, this message translates to:
  /// **'I can\'t find my hadj'**
  String get cant_find_hadj;

  /// No description provided for @no_image_taken.
  ///
  /// In en, this message translates to:
  /// **'No image was taken'**
  String get no_image_taken;

  /// No description provided for @found_hadj.
  ///
  /// In en, this message translates to:
  /// **'You found a missing hadj'**
  String get found_hadj;

  /// No description provided for @scan_face.
  ///
  /// In en, this message translates to:
  /// **'Scan face'**
  String get scan_face;

  /// No description provided for @face_scan_title.
  ///
  /// In en, this message translates to:
  /// **'Scan full face'**
  String get face_scan_title;

  /// No description provided for @no_match_found.
  ///
  /// In en, this message translates to:
  /// **'No match found'**
  String get no_match_found;

  /// No description provided for @match_found.
  ///
  /// In en, this message translates to:
  /// **'Match found'**
  String get match_found;

  /// No description provided for @no_face_detected.
  ///
  /// In en, this message translates to:
  /// **'No face detected'**
  String get no_face_detected;

  /// No description provided for @make_sure_face.
  ///
  /// In en, this message translates to:
  /// **'Make sure the face is fully visible in the frame'**
  String get make_sure_face;

  /// No description provided for @scan_again.
  ///
  /// In en, this message translates to:
  /// **'Scan again'**
  String get scan_again;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @missing_person_alert.
  ///
  /// In en, this message translates to:
  /// **'Missing person alert'**
  String get missing_person_alert;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @missging_person_reported.
  ///
  /// In en, this message translates to:
  /// **'A missing person has been reported'**
  String get missging_person_reported;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @nationality.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get nationality;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phone;

  /// No description provided for @open_full_report.
  ///
  /// In en, this message translates to:
  /// **'Open full report'**
  String get open_full_report;

  /// No description provided for @send_report.
  ///
  /// In en, this message translates to:
  /// **'Send report'**
  String get send_report;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @blood_type.
  ///
  /// In en, this message translates to:
  /// **'Blood type'**
  String get blood_type;

  /// No description provided for @emergency_contact.
  ///
  /// In en, this message translates to:
  /// **'Emergency contact'**
  String get emergency_contact;

  /// No description provided for @illness.
  ///
  /// In en, this message translates to:
  /// **'Illness'**
  String get illness;

  /// No description provided for @call_emergency.
  ///
  /// In en, this message translates to:
  /// **'Call emergency'**
  String get call_emergency;

  /// No description provided for @settings_section.
  ///
  /// In en, this message translates to:
  /// **'--------------------------------------------------------------------'**
  String get settings_section;

  /// No description provided for @settings_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_title;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @profile_overview.
  ///
  /// In en, this message translates to:
  /// **'Profile overview'**
  String get profile_overview;

  /// No description provided for @full_name.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get full_name;

  /// No description provided for @languages.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languages;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @face_scanning_guide.
  ///
  /// In en, this message translates to:
  /// **'Face scanning guide'**
  String get face_scanning_guide;

  /// No description provided for @distance_message.
  ///
  /// In en, this message translates to:
  /// **'- the distance between the person and the camera should be between 30cm to 50cm'**
  String get distance_message;

  /// No description provided for @got_it.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get got_it;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
