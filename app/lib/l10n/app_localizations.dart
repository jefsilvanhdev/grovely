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

  /// Public name of the app.
  ///
  /// In en, this message translates to:
  /// **'Grovely'**
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

  /// No description provided for @streakStart.
  ///
  /// In en, this message translates to:
  /// **'Start a streak'**
  String get streakStart;

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'{count}-day streak'**
  String streakDays(int count);

  /// No description provided for @focusLiveNow.
  ///
  /// In en, this message translates to:
  /// **'{count} focusing now'**
  String focusLiveNow(int count);

  /// No description provided for @focusPreview.
  ///
  /// In en, this message translates to:
  /// **'A young {species} in {minutes} min.'**
  String focusPreview(String species, int minutes);

  /// No description provided for @focusPlant.
  ///
  /// In en, this message translates to:
  /// **'Plant & focus'**
  String get focusPlant;

  /// No description provided for @focusGiveUpConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave now? Your tree will wither.'**
  String get focusGiveUpConfirmTitle;

  /// No description provided for @focusKeepFocusing.
  ///
  /// In en, this message translates to:
  /// **'Keep focusing'**
  String get focusKeepFocusing;

  /// No description provided for @statMinFocused.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min focused'**
  String statMinFocused(int minutes);

  /// No description provided for @statTrees.
  ///
  /// In en, this message translates to:
  /// **'{count} trees'**
  String statTrees(int count);

  /// No description provided for @statHoursFocused.
  ///
  /// In en, this message translates to:
  /// **'{hours}h focused'**
  String statHoursFocused(int hours);

  /// No description provided for @statLongest.
  ///
  /// In en, this message translates to:
  /// **'Longest: {count} days'**
  String statLongest(int count);

  /// No description provided for @statSpecies.
  ///
  /// In en, this message translates to:
  /// **'{count}/6 species'**
  String statSpecies(int count);

  /// No description provided for @addedToGarden.
  ///
  /// In en, this message translates to:
  /// **'Added to your garden'**
  String get addedToGarden;

  /// No description provided for @plantAnother.
  ///
  /// In en, this message translates to:
  /// **'Plant another'**
  String get plantAnother;

  /// No description provided for @viewGarden.
  ///
  /// In en, this message translates to:
  /// **'View garden'**
  String get viewGarden;

  /// No description provided for @reviveWithVideo.
  ///
  /// In en, this message translates to:
  /// **'Revive with a short video'**
  String get reviveWithVideo;

  /// No description provided for @startFresh.
  ///
  /// In en, this message translates to:
  /// **'Start fresh'**
  String get startFresh;

  /// No description provided for @reviveSheetBody.
  ///
  /// In en, this message translates to:
  /// **'Watch a 30-second video to revive this tree.'**
  String get reviveSheetBody;

  /// No description provided for @watchAndRevive.
  ///
  /// In en, this message translates to:
  /// **'Watch & revive'**
  String get watchAndRevive;

  /// No description provided for @noThanks.
  ///
  /// In en, this message translates to:
  /// **'No thanks'**
  String get noThanks;

  /// No description provided for @reviveUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the video — your tree\'s still here to replant.'**
  String get reviveUnavailable;

  /// No description provided for @witheredBodyKind.
  ///
  /// In en, this message translates to:
  /// **'You left before the session finished — it happens. Want to bring it back?'**
  String get witheredBodyKind;

  /// No description provided for @plantFirst.
  ///
  /// In en, this message translates to:
  /// **'Plant your first tree'**
  String get plantFirst;

  /// No description provided for @gardenWaiting.
  ///
  /// In en, this message translates to:
  /// **'Your garden is waiting.'**
  String get gardenWaiting;

  /// No description provided for @gardenWaitingSub.
  ///
  /// In en, this message translates to:
  /// **'Finish a focus session to plant your first tree.'**
  String get gardenWaitingSub;

  /// No description provided for @speciesOak.
  ///
  /// In en, this message translates to:
  /// **'oak'**
  String get speciesOak;

  /// No description provided for @speciesPine.
  ///
  /// In en, this message translates to:
  /// **'pine'**
  String get speciesPine;

  /// No description provided for @speciesRoundBush.
  ///
  /// In en, this message translates to:
  /// **'bush'**
  String get speciesRoundBush;

  /// No description provided for @speciesWillow.
  ///
  /// In en, this message translates to:
  /// **'willow'**
  String get speciesWillow;

  /// No description provided for @speciesBirch.
  ///
  /// In en, this message translates to:
  /// **'birch'**
  String get speciesBirch;

  /// No description provided for @speciesCherryBlossom.
  ///
  /// In en, this message translates to:
  /// **'cherry blossom'**
  String get speciesCherryBlossom;

  /// No description provided for @commonSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get commonSkip;

  /// No description provided for @onbWelcomeSub.
  ///
  /// In en, this message translates to:
  /// **'Plant a tree with every focused session. Watch your grove grow.'**
  String get onbWelcomeSub;

  /// No description provided for @onbGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onbGetStarted;

  /// No description provided for @onbHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get onbHaveAccount;

  /// No description provided for @onbNotifTitle.
  ///
  /// In en, this message translates to:
  /// **'Gentle nudges, never noise.'**
  String get onbNotifTitle;

  /// No description provided for @onbNotifBullet1.
  ///
  /// In en, this message translates to:
  /// **'A daily reminder to plant one tree'**
  String get onbNotifBullet1;

  /// No description provided for @onbNotifBullet2.
  ///
  /// In en, this message translates to:
  /// **'We\'ll help you save a streak before it breaks'**
  String get onbNotifBullet2;

  /// No description provided for @onbNotifBullet3.
  ///
  /// In en, this message translates to:
  /// **'Know when your circle is focusing'**
  String get onbNotifBullet3;

  /// No description provided for @onbNotifCta.
  ///
  /// In en, this message translates to:
  /// **'Turn on reminders'**
  String get onbNotifCta;

  /// No description provided for @onbNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get onbNotNow;

  /// No description provided for @onbSocialTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus your way.'**
  String get onbSocialTitle;

  /// No description provided for @onbSocialSub.
  ///
  /// In en, this message translates to:
  /// **'You can always change this later.'**
  String get onbSocialSub;

  /// No description provided for @onbSoloTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus solo'**
  String get onbSoloTitle;

  /// No description provided for @onbSoloDesc.
  ///
  /// In en, this message translates to:
  /// **'Just you and your grove.'**
  String get onbSoloDesc;

  /// No description provided for @onbCircleTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus with a circle'**
  String get onbCircleTitle;

  /// No description provided for @onbCircleDesc.
  ///
  /// In en, this message translates to:
  /// **'Grow a shared garden with 6–12 people.'**
  String get onbCircleDesc;

  /// No description provided for @onbRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get onbRecommended;

  /// No description provided for @onbPrivacy.
  ///
  /// In en, this message translates to:
  /// **'We only ever share your first name and tree count.'**
  String get onbPrivacy;

  /// No description provided for @onbGuidedCoach.
  ///
  /// In en, this message translates to:
  /// **'Let\'s plant your first tree. Stay here for 5 minutes — that\'s it.'**
  String get onbGuidedCoach;

  /// No description provided for @onbBegin.
  ///
  /// In en, this message translates to:
  /// **'Begin'**
  String get onbBegin;

  /// No description provided for @onbGuidedDone.
  ///
  /// In en, this message translates to:
  /// **'Your first tree! 🌱 This one\'s on us.'**
  String get onbGuidedDone;

  /// No description provided for @pwTitle.
  ///
  /// In en, this message translates to:
  /// **'Go deeper with Grovely Premium.'**
  String get pwTitle;

  /// No description provided for @pwSub.
  ///
  /// In en, this message translates to:
  /// **'Everything you love, plus more ways to grow.'**
  String get pwSub;

  /// No description provided for @pwTrialCta.
  ///
  /// In en, this message translates to:
  /// **'Start 21-day free trial'**
  String get pwTrialCta;

  /// No description provided for @pwTrialSub.
  ///
  /// In en, this message translates to:
  /// **'Free for 21 days, then {price}. Cancel anytime in two taps.'**
  String pwTrialSub(String price);

  /// No description provided for @pwAnnual.
  ///
  /// In en, this message translates to:
  /// **'Annual'**
  String get pwAnnual;

  /// No description provided for @pwMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get pwMonthly;

  /// No description provided for @pwSave.
  ///
  /// In en, this message translates to:
  /// **'Save 40%'**
  String get pwSave;

  /// No description provided for @pwContinueFree.
  ///
  /// In en, this message translates to:
  /// **'Continue with Free'**
  String get pwContinueFree;

  /// No description provided for @pwRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get pwRestore;

  /// No description provided for @pwFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get pwFree;

  /// No description provided for @pwPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get pwPremium;

  /// No description provided for @pwRowSoloFocus.
  ///
  /// In en, this message translates to:
  /// **'Unlimited solo focus'**
  String get pwRowSoloFocus;

  /// No description provided for @pwRowGarden.
  ///
  /// In en, this message translates to:
  /// **'Full garden & streak'**
  String get pwRowGarden;

  /// No description provided for @pwRowOneCircle.
  ///
  /// In en, this message translates to:
  /// **'Join 1 circle'**
  String get pwRowOneCircle;

  /// No description provided for @pwRowCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom durations'**
  String get pwRowCustom;

  /// No description provided for @pwRowSpecies.
  ///
  /// In en, this message translates to:
  /// **'All species & seasonal trees'**
  String get pwRowSpecies;

  /// No description provided for @pwRowStats.
  ///
  /// In en, this message translates to:
  /// **'Advanced stats'**
  String get pwRowStats;

  /// No description provided for @pwRowMultiCircle.
  ///
  /// In en, this message translates to:
  /// **'Multiple circles'**
  String get pwRowMultiCircle;

  /// No description provided for @pwRowRecap.
  ///
  /// In en, this message translates to:
  /// **'Recap themes'**
  String get pwRowRecap;

  /// No description provided for @pwPriceTbd.
  ///
  /// In en, this message translates to:
  /// **'price TBD'**
  String get pwPriceTbd;

  /// No description provided for @profileGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get profileGuest;

  /// No description provided for @profileSaveProgress.
  ///
  /// In en, this message translates to:
  /// **'Save your progress'**
  String get profileSaveProgress;

  /// No description provided for @profileFreePlan.
  ///
  /// In en, this message translates to:
  /// **'Free plan'**
  String get profileFreePlan;

  /// No description provided for @profileLifetime.
  ///
  /// In en, this message translates to:
  /// **'Lifetime'**
  String get profileLifetime;

  /// No description provided for @rowAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get rowAccount;

  /// No description provided for @rowSubscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get rowSubscription;

  /// No description provided for @rowNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get rowNotifications;

  /// No description provided for @rowAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get rowAppearance;

  /// No description provided for @rowPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get rowPrivacy;

  /// No description provided for @rowTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get rowTerms;

  /// No description provided for @rowSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get rowSignOut;

  /// No description provided for @rowAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get rowAbout;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;
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
