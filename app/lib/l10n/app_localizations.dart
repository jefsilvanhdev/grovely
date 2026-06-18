import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// Working title of the app (public name TBD by Agent A).
  ///
  /// In en, this message translates to:
  /// **'Plantio Coletivo'**
  String get appName;

  /// Bottom nav label — focus session tab.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get navFocus;

  /// Bottom nav label — personal garden tab.
  ///
  /// In en, this message translates to:
  /// **'Garden'**
  String get navGarden;

  /// Bottom nav label — circles / collective garden tab.
  ///
  /// In en, this message translates to:
  /// **'Circle'**
  String get navCircle;

  /// Bottom nav label — weekly league tab.
  ///
  /// In en, this message translates to:
  /// **'League'**
  String get navLeague;

  /// Bottom nav label — profile / settings tab.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @focusTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus session'**
  String get focusTitle;

  /// No description provided for @focusSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Plant a tree by staying focused.'**
  String get focusSubtitle;

  /// No description provided for @gardenTitle.
  ///
  /// In en, this message translates to:
  /// **'Your garden'**
  String get gardenTitle;

  /// No description provided for @gardenEmpty.
  ///
  /// In en, this message translates to:
  /// **'No trees yet. Finish a focus session to plant your first.'**
  String get gardenEmpty;

  /// No description provided for @circleTitle.
  ///
  /// In en, this message translates to:
  /// **'Circles'**
  String get circleTitle;

  /// No description provided for @circleEmpty.
  ///
  /// In en, this message translates to:
  /// **'Join a circle to grow a garden together.'**
  String get circleEmpty;

  /// No description provided for @leagueTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly league'**
  String get leagueTitle;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @onboardingWelcome.
  ///
  /// In en, this message translates to:
  /// **'Grow focus, together.'**
  String get onboardingWelcome;

  /// No description provided for @paywallTitle.
  ///
  /// In en, this message translates to:
  /// **'Go Premium'**
  String get paywallTitle;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get commonLoading;

  /// No description provided for @commonError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get commonError;

  /// No description provided for @focusStart.
  ///
  /// In en, this message translates to:
  /// **'Start focus'**
  String get focusStart;

  /// No description provided for @focusGiveUp.
  ///
  /// In en, this message translates to:
  /// **'Give up'**
  String get focusGiveUp;

  /// No description provided for @focusKeepGrowing.
  ///
  /// In en, this message translates to:
  /// **'Stay in the app to keep your tree growing.'**
  String get focusKeepGrowing;

  /// No description provided for @focusCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Tree planted!'**
  String get focusCompletedTitle;

  /// No description provided for @focusCompletedBody.
  ///
  /// In en, this message translates to:
  /// **'You focused for {minutes} minutes.'**
  String focusCompletedBody(int minutes);

  /// No description provided for @focusWitheredTitle.
  ///
  /// In en, this message translates to:
  /// **'Your tree withered'**
  String get focusWitheredTitle;

  /// No description provided for @focusWitheredBody.
  ///
  /// In en, this message translates to:
  /// **'You left before the session ended. Try again.'**
  String get focusWitheredBody;

  /// No description provided for @focusNewSession.
  ///
  /// In en, this message translates to:
  /// **'New session'**
  String get focusNewSession;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutesShort(int minutes);

  /// No description provided for @gardenTreeCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No trees yet} =1{1 tree} other{{count} trees}}'**
  String gardenTreeCount(int count);
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
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
