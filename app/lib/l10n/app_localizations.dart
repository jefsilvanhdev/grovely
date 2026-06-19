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

  /// No description provided for @navFocus.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get navFocus;

  /// No description provided for @navGarden.
  ///
  /// In en, this message translates to:
  /// **'Garden'**
  String get navGarden;

  /// No description provided for @navCircle.
  ///
  /// In en, this message translates to:
  /// **'Circle'**
  String get navCircle;

  /// No description provided for @navLeague.
  ///
  /// In en, this message translates to:
  /// **'League'**
  String get navLeague;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @focusTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get focusTitle;

  /// No description provided for @focusSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stay focused and watch it grow.'**
  String get focusSubtitle;

  /// No description provided for @gardenTitle.
  ///
  /// In en, this message translates to:
  /// **'Your garden'**
  String get gardenTitle;

  /// No description provided for @gardenEmpty.
  ///
  /// In en, this message translates to:
  /// **'No trees yet — your first focus plants one.'**
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
  /// **'League'**
  String get leagueTitle;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @onboardingWelcome.
  ///
  /// In en, this message translates to:
  /// **'Grow your focus. Together.'**
  String get onboardingWelcome;

  /// No description provided for @paywallTitle.
  ///
  /// In en, this message translates to:
  /// **'Grovely Premium'**
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
  /// **'Try again'**
  String get commonRetry;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get commonLoading;

  /// No description provided for @commonError.
  ///
  /// In en, this message translates to:
  /// **'That didn\'t work — let\'s try again.'**
  String get commonError;

  /// No description provided for @focusStart.
  ///
  /// In en, this message translates to:
  /// **'Start focus'**
  String get focusStart;

  /// No description provided for @focusGiveUp.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get focusGiveUp;

  /// No description provided for @focusKeepGrowing.
  ///
  /// In en, this message translates to:
  /// **'Stay here. Your tree\'s growing.'**
  String get focusKeepGrowing;

  /// No description provided for @focusCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Tree planted!'**
  String get focusCompletedTitle;

  /// No description provided for @focusCompletedBody.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes of focus, well spent.'**
  String focusCompletedBody(int minutes);

  /// No description provided for @focusWitheredTitle.
  ///
  /// In en, this message translates to:
  /// **'Your tree didn\'t make it'**
  String get focusWitheredTitle;

  /// No description provided for @focusWitheredBody.
  ///
  /// In en, this message translates to:
  /// **'You stepped away before it finished. It happens.'**
  String get focusWitheredBody;

  /// No description provided for @focusNewSession.
  ///
  /// In en, this message translates to:
  /// **'Start again'**
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
  /// **'A {species}, grown in {minutes} min.'**
  String focusPreview(String species, int minutes);

  /// No description provided for @focusPlant.
  ///
  /// In en, this message translates to:
  /// **'Plant & focus'**
  String get focusPlant;

  /// No description provided for @focusGiveUpConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave now? Your tree won\'t make it.'**
  String get focusGiveUpConfirmTitle;

  /// No description provided for @focusKeepFocusing.
  ///
  /// In en, this message translates to:
  /// **'Keep growing'**
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
  /// **'Best: {count} days'**
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
  /// **'See my garden'**
  String get viewGarden;

  /// No description provided for @reviveWithVideo.
  ///
  /// In en, this message translates to:
  /// **'Bring it back with a short video'**
  String get reviveWithVideo;

  /// No description provided for @startFresh.
  ///
  /// In en, this message translates to:
  /// **'Start fresh'**
  String get startFresh;

  /// No description provided for @reviveSheetBody.
  ///
  /// In en, this message translates to:
  /// **'A 30-second video brings this tree back.'**
  String get reviveSheetBody;

  /// No description provided for @watchAndRevive.
  ///
  /// In en, this message translates to:
  /// **'Watch & bring it back'**
  String get watchAndRevive;

  /// No description provided for @noThanks.
  ///
  /// In en, this message translates to:
  /// **'No thanks'**
  String get noThanks;

  /// No description provided for @reviveUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No video right now — but you can replant it.'**
  String get reviveUnavailable;

  /// No description provided for @witheredBodyKind.
  ///
  /// In en, this message translates to:
  /// **'You stepped away before it finished — it happens. Want it back?'**
  String get witheredBodyKind;

  /// No description provided for @plantFirst.
  ///
  /// In en, this message translates to:
  /// **'Plant my first tree'**
  String get plantFirst;

  /// No description provided for @gardenWaiting.
  ///
  /// In en, this message translates to:
  /// **'Your garden starts here.'**
  String get gardenWaiting;

  /// No description provided for @gardenWaitingSub.
  ///
  /// In en, this message translates to:
  /// **'One focused session plants your first tree.'**
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
  /// **'Every focused minute plants a tree. Watch your grove grow.'**
  String get onbWelcomeSub;

  /// No description provided for @onbGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Plant my first tree'**
  String get onbGetStarted;

  /// No description provided for @onbHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get onbHaveAccount;

  /// No description provided for @onbNotifTitle.
  ///
  /// In en, this message translates to:
  /// **'A nudge when it helps. Never noise.'**
  String get onbNotifTitle;

  /// No description provided for @onbNotifBullet1.
  ///
  /// In en, this message translates to:
  /// **'A daily nudge to plant one tree'**
  String get onbNotifBullet1;

  /// No description provided for @onbNotifBullet2.
  ///
  /// In en, this message translates to:
  /// **'A heads-up before your streak slips'**
  String get onbNotifBullet2;

  /// No description provided for @onbNotifBullet3.
  ///
  /// In en, this message translates to:
  /// **'A ping when your circle starts focusing'**
  String get onbNotifBullet3;

  /// No description provided for @onbNotifCta.
  ///
  /// In en, this message translates to:
  /// **'Turn on reminders'**
  String get onbNotifCta;

  /// No description provided for @onbNotNow.
  ///
  /// In en, this message translates to:
  /// **'Maybe later'**
  String get onbNotNow;

  /// No description provided for @onbSocialTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus your way.'**
  String get onbSocialTitle;

  /// No description provided for @onbSocialSub.
  ///
  /// In en, this message translates to:
  /// **'Change this anytime.'**
  String get onbSocialSub;

  /// No description provided for @onbSoloTitle.
  ///
  /// In en, this message translates to:
  /// **'On my own'**
  String get onbSoloTitle;

  /// No description provided for @onbSoloDesc.
  ///
  /// In en, this message translates to:
  /// **'Just you and your grove.'**
  String get onbSoloDesc;

  /// No description provided for @onbCircleTitle.
  ///
  /// In en, this message translates to:
  /// **'With a circle'**
  String get onbCircleTitle;

  /// No description provided for @onbCircleDesc.
  ///
  /// In en, this message translates to:
  /// **'Grow one garden with 6–12 people.'**
  String get onbCircleDesc;

  /// No description provided for @onbRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get onbRecommended;

  /// No description provided for @onbPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Only your first name and tree count are ever shared.'**
  String get onbPrivacy;

  /// No description provided for @onbGuidedCoach.
  ///
  /// In en, this message translates to:
  /// **'Let\'s plant your first one. Just stay here 30 seconds.'**
  String get onbGuidedCoach;

  /// No description provided for @onbBegin.
  ///
  /// In en, this message translates to:
  /// **'Plant it'**
  String get onbBegin;

  /// No description provided for @onbGuidedDone.
  ///
  /// In en, this message translates to:
  /// **'Your first tree. 🌱 On us.'**
  String get onbGuidedDone;

  /// No description provided for @pwTitle.
  ///
  /// In en, this message translates to:
  /// **'More room to grow.'**
  String get pwTitle;

  /// No description provided for @pwSub.
  ///
  /// In en, this message translates to:
  /// **'Keep everything free, unlock a little more.'**
  String get pwSub;

  /// No description provided for @pwTrialCta.
  ///
  /// In en, this message translates to:
  /// **'Try free for 21 days'**
  String get pwTrialCta;

  /// No description provided for @pwTrialSub.
  ///
  /// In en, this message translates to:
  /// **'Free for 21 days, then {price}. Cancel anytime, two taps.'**
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
  /// **'Stay on Free'**
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
  /// **'Save my progress'**
  String get profileSaveProgress;

  /// No description provided for @profileFreePlan.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get profileFreePlan;

  /// No description provided for @profileLifetime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
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

  /// No description provided for @recapTitle.
  ///
  /// In en, this message translates to:
  /// **'Your week'**
  String get recapTitle;

  /// No description provided for @recapHero.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 tree this week} other{{count} trees this week}}'**
  String recapHero(int count);

  /// No description provided for @recapHeroLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{tree this week} other{trees this week}}'**
  String recapHeroLabel(int count);

  /// No description provided for @recapSub.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m in focus'**
  String recapSub(int hours, int minutes);

  /// No description provided for @recapFooter.
  ///
  /// In en, this message translates to:
  /// **'Grown with Grovely'**
  String get recapFooter;

  /// No description provided for @recapShare.
  ///
  /// In en, this message translates to:
  /// **'Share my week'**
  String get recapShare;

  /// No description provided for @recapEmpty.
  ///
  /// In en, this message translates to:
  /// **'A fresh week to grow.'**
  String get recapEmpty;

  /// No description provided for @recapEmptySub.
  ///
  /// In en, this message translates to:
  /// **'Plant your first tree to start the week.'**
  String get recapEmptySub;

  /// No description provided for @circleEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Grow together.'**
  String get circleEmptyTitle;

  /// No description provided for @circleEmptySub.
  ///
  /// In en, this message translates to:
  /// **'6–12 friends, one shared garden, a friendly weekly league.'**
  String get circleEmptySub;

  /// No description provided for @circleCreate.
  ///
  /// In en, this message translates to:
  /// **'Start a circle'**
  String get circleCreate;

  /// No description provided for @circleJoin.
  ///
  /// In en, this message translates to:
  /// **'Join with a code'**
  String get circleJoin;

  /// No description provided for @circlePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Members only see your first name and tree count.'**
  String get circlePrivacy;

  /// No description provided for @circleNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Circle name'**
  String get circleNameLabel;

  /// No description provided for @circleNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Deep Work Club'**
  String get circleNameHint;

  /// No description provided for @circleCreateCta.
  ///
  /// In en, this message translates to:
  /// **'Create circle'**
  String get circleCreateCta;

  /// No description provided for @circleJoinTitle.
  ///
  /// In en, this message translates to:
  /// **'Join a circle'**
  String get circleJoinTitle;

  /// No description provided for @circleCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Invite code'**
  String get circleCodeLabel;

  /// No description provided for @circleJoinCta.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get circleJoinCta;

  /// No description provided for @circleInvalidCode.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find a circle for that code.'**
  String get circleInvalidCode;

  /// No description provided for @circleFull.
  ///
  /// In en, this message translates to:
  /// **'This circle\'s full for now.'**
  String get circleFull;

  /// No description provided for @circleInvite.
  ///
  /// In en, this message translates to:
  /// **'Share invite'**
  String get circleInvite;

  /// No description provided for @circleMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get circleMembers;

  /// No description provided for @circleGoal.
  ///
  /// In en, this message translates to:
  /// **'{planted} of {goal} trees this week'**
  String circleGoal(int planted, int goal);

  /// No description provided for @circleLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave circle'**
  String get circleLeave;

  /// No description provided for @circleLeaveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Leave circle?'**
  String get circleLeaveConfirm;

  /// No description provided for @circleLeaveBody.
  ///
  /// In en, this message translates to:
  /// **'You can come back anytime with the code.'**
  String get circleLeaveBody;

  /// No description provided for @circleStay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get circleStay;

  /// No description provided for @memberWeekly.
  ///
  /// In en, this message translates to:
  /// **'{count} this week'**
  String memberWeekly(int count);

  /// No description provided for @leagueSolo.
  ///
  /// In en, this message translates to:
  /// **'Join a circle and the league opens up.'**
  String get leagueSolo;

  /// No description provided for @leagueTitleWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get leagueTitleWeek;

  /// No description provided for @leagueYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get leagueYou;
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
