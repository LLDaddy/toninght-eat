import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

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
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'What to Eat Tonight'**
  String get appTitle;

  /// No description provided for @commonDish.
  ///
  /// In en, this message translates to:
  /// **'Dish'**
  String get commonDish;

  /// No description provided for @commonFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get commonFavorites;

  /// No description provided for @commonHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get commonHome;

  /// No description provided for @commonLock.
  ///
  /// In en, this message translates to:
  /// **'Lock'**
  String get commonLock;

  /// No description provided for @commonLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get commonLocked;

  /// No description provided for @commonMine.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get commonMine;

  /// No description provided for @commonRecipes.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get commonRecipes;

  /// No description provided for @commonRegenerate.
  ///
  /// In en, this message translates to:
  /// **'Draw Again'**
  String get commonRegenerate;

  /// No description provided for @commonReplaceThis.
  ///
  /// In en, this message translates to:
  /// **'Replace Dish'**
  String get commonReplaceThis;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonSoup.
  ///
  /// In en, this message translates to:
  /// **'Soup'**
  String get commonSoup;

  /// No description provided for @commonUnselected.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get commonUnselected;

  /// No description provided for @homePhase1Done.
  ///
  /// In en, this message translates to:
  /// **'Phase 1 complete'**
  String get homePhase1Done;

  /// No description provided for @loginInstruction.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number to get a verification code.'**
  String get loginInstruction;

  /// No description provided for @loginOtpSent.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent.'**
  String get loginOtpSent;

  /// No description provided for @loginPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 13800138000 or +8613800138000'**
  String get loginPhoneHint;

  /// No description provided for @loginPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number.'**
  String get loginPhoneInvalid;

  /// No description provided for @loginPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get loginPhoneLabel;

  /// No description provided for @loginPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get loginPhoneRequired;

  /// No description provided for @loginSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send code: {error}'**
  String loginSendFailed(String error);

  /// No description provided for @loginSendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get loginSendOtp;

  /// No description provided for @loginSending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get loginSending;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Log In with Phone'**
  String get loginTitle;

  /// No description provided for @mainShellFavoritesTabPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Favorites tab coming soon'**
  String get mainShellFavoritesTabPlaceholder;

  /// No description provided for @mainShellLogoutTooltip.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get mainShellLogoutTooltip;

  /// No description provided for @mainShellMineTabPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Profile tab coming soon'**
  String get mainShellMineTabPlaceholder;

  /// No description provided for @mainShellRecipesTabPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Recipes tab coming soon'**
  String get mainShellRecipesTabPlaceholder;

  /// No description provided for @recipesSearchLabel.
  ///
  /// In en, this message translates to:
  /// **'Search Recipes'**
  String get recipesSearchLabel;

  /// No description provided for @recipesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Name, cuisine, or taste'**
  String get recipesSearchHint;

  /// No description provided for @recipesFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get recipesFilterAll;

  /// No description provided for @recipesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} recipes'**
  String recipesCount(int count);

  /// No description provided for @recipesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No recipes match your filters.'**
  String get recipesEmpty;

  /// No description provided for @recipesClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get recipesClearFilters;

  /// No description provided for @recipesLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load recipes: {error}'**
  String recipesLoadFailed(String error);

  /// No description provided for @onboardingAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get onboardingAdd;

  /// No description provided for @onboardingCityLabel.
  ///
  /// In en, this message translates to:
  /// **'City *'**
  String get onboardingCityLabel;

  /// No description provided for @onboardingCityRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a city'**
  String get onboardingCityRequired;

  /// No description provided for @onboardingDislikedHint.
  ///
  /// In en, this message translates to:
  /// **'Type ingredient'**
  String get onboardingDislikedHint;

  /// No description provided for @onboardingDislikedLabel.
  ///
  /// In en, this message translates to:
  /// **'Disliked Ingredients (multi-select/input)'**
  String get onboardingDislikedLabel;

  /// No description provided for @onboardingFamilySizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Family Members *'**
  String get onboardingFamilySizeLabel;

  /// No description provided for @onboardingFamilySizeRangeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a number between 1 and 20'**
  String get onboardingFamilySizeRangeInvalid;

  /// No description provided for @onboardingFamilySizeRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter family size'**
  String get onboardingFamilySizeRequired;

  /// No description provided for @onboardingMenuPatternLabel.
  ///
  /// In en, this message translates to:
  /// **'Menu Pattern *'**
  String get onboardingMenuPatternLabel;

  /// No description provided for @onboardingMenuPatternRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a menu pattern'**
  String get onboardingMenuPatternRequired;

  /// No description provided for @onboardingPreferredCuisinesLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred Cuisines (multi-select)'**
  String get onboardingPreferredCuisinesLabel;

  /// No description provided for @onboardingProvinceLabel.
  ///
  /// In en, this message translates to:
  /// **'Province *'**
  String get onboardingProvinceLabel;

  /// No description provided for @onboardingProvinceRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a province'**
  String get onboardingProvinceRequired;

  /// No description provided for @onboardingRequiredFieldsIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Complete all required fields.'**
  String get onboardingRequiredFieldsIncomplete;

  /// No description provided for @onboardingSave.
  ///
  /// In en, this message translates to:
  /// **'Save Setup'**
  String get onboardingSave;

  /// No description provided for @onboardingSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save setup: {error}'**
  String onboardingSaveFailed(String error);

  /// No description provided for @onboardingSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Setup saved.'**
  String get onboardingSaveSuccess;

  /// No description provided for @onboardingSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get onboardingSaving;

  /// No description provided for @onboardingSectionDisliked.
  ///
  /// In en, this message translates to:
  /// **'Disliked Ingredients'**
  String get onboardingSectionDisliked;

  /// No description provided for @onboardingSectionMenuPattern.
  ///
  /// In en, this message translates to:
  /// **'Menu Pattern'**
  String get onboardingSectionMenuPattern;

  /// No description provided for @onboardingSectionPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get onboardingSectionPreferences;

  /// No description provided for @onboardingSectionRegionFamily.
  ///
  /// In en, this message translates to:
  /// **'Location & Family'**
  String get onboardingSectionRegionFamily;

  /// No description provided for @onboardingSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please log in again.'**
  String get onboardingSessionExpired;

  /// No description provided for @onboardingTastePreferencesLabel.
  ///
  /// In en, this message translates to:
  /// **'Taste Preferences *'**
  String get onboardingTastePreferencesLabel;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'First-Time Setup'**
  String get onboardingTitle;

  /// No description provided for @otpCodeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a 6-digit code.'**
  String get otpCodeInvalid;

  /// No description provided for @otpCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'6-digit code'**
  String get otpCodeLabel;

  /// No description provided for @otpCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code.'**
  String get otpCodeRequired;

  /// No description provided for @otpLoginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logged in successfully.'**
  String get otpLoginSuccess;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'Code sent to {phone}'**
  String otpSentTo(String phone);

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Verification Code'**
  String get otpTitle;

  /// No description provided for @otpVerifyAndLogin.
  ///
  /// In en, this message translates to:
  /// **'Verify & Log In'**
  String get otpVerifyAndLogin;

  /// No description provided for @otpVerifyFailed.
  ///
  /// In en, this message translates to:
  /// **'Code is invalid or expired: {error}'**
  String otpVerifyFailed(String error);

  /// No description provided for @otpVerifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying...'**
  String get otpVerifying;

  /// No description provided for @recipeDetailAddTodayMenuButton.
  ///
  /// In en, this message translates to:
  /// **'Add to Today\'s Menu'**
  String get recipeDetailAddTodayMenuButton;

  /// No description provided for @recipeDetailAddTodayMenuPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Add to menu coming soon'**
  String get recipeDetailAddTodayMenuPlaceholder;

  /// No description provided for @recipeDetailFavoriteButton.
  ///
  /// In en, this message translates to:
  /// **'Save Recipe'**
  String get recipeDetailFavoriteButton;

  /// No description provided for @recipeDetailFavoritePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Favorites feature coming soon'**
  String get recipeDetailFavoritePlaceholder;

  /// No description provided for @recipeDetailIngredientBullet.
  ///
  /// In en, this message translates to:
  /// **'- {ingredient}'**
  String recipeDetailIngredientBullet(String ingredient);

  /// No description provided for @recipeDetailIngredientsTitle.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get recipeDetailIngredientsTitle;

  /// No description provided for @recipeDetailStepsTitle.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get recipeDetailStepsTitle;

  /// No description provided for @recipeDetailSummary.
  ///
  /// In en, this message translates to:
  /// **'{type} | {cuisine} | {minutes} min'**
  String recipeDetailSummary(String type, String cuisine, int minutes);

  /// No description provided for @recipeDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Recipe Details'**
  String get recipeDetailTitle;

  /// No description provided for @startupMissingEnv.
  ///
  /// In en, this message translates to:
  /// **'Missing .env. Set it up from .env.example first.'**
  String get startupMissingEnv;

  /// No description provided for @startupMissingSupabaseKeys.
  ///
  /// In en, this message translates to:
  /// **'Missing SUPABASE_URL or SUPABASE_ANON_KEY.'**
  String get startupMissingSupabaseKeys;

  /// No description provided for @tarotDrawFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t draw menu: {error}'**
  String tarotDrawFailed(String error);

  /// No description provided for @tarotDrawTodayMenuButton.
  ///
  /// In en, this message translates to:
  /// **'Draw Menu'**
  String get tarotDrawTodayMenuButton;

  /// No description provided for @tarotDrawingButton.
  ///
  /// In en, this message translates to:
  /// **'Drawing...'**
  String get tarotDrawingButton;

  /// No description provided for @tarotDrawingHint.
  ///
  /// In en, this message translates to:
  /// **'Shuffling cards and revealing menu...'**
  String get tarotDrawingHint;

  /// No description provided for @tarotPhaseDrawing.
  ///
  /// In en, this message translates to:
  /// **'Drawing'**
  String get tarotPhaseDrawing;

  /// No description provided for @tarotPhaseIdle.
  ///
  /// In en, this message translates to:
  /// **'Ready to Draw'**
  String get tarotPhaseIdle;

  /// No description provided for @tarotPhaseResult.
  ///
  /// In en, this message translates to:
  /// **'Menu Revealed'**
  String get tarotPhaseResult;

  /// No description provided for @tarotReadyHint.
  ///
  /// In en, this message translates to:
  /// **'Tap Draw to reveal today\'s menu.'**
  String get tarotReadyHint;

  /// No description provided for @tarotRedraw.
  ///
  /// In en, this message translates to:
  /// **'Draw Again'**
  String get tarotRedraw;

  /// No description provided for @tarotResultLine.
  ///
  /// In en, this message translates to:
  /// **'{name} | {type} | {minutes} min'**
  String tarotResultLine(String name, String type, int minutes);

  /// No description provided for @tarotResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Menu'**
  String get tarotResultTitle;

  /// No description provided for @tarotTitle.
  ///
  /// In en, this message translates to:
  /// **'Dinner Tarot'**
  String get tarotTitle;

  /// No description provided for @tarotUseThisMenu.
  ///
  /// In en, this message translates to:
  /// **'Use Menu'**
  String get tarotUseThisMenu;

  /// No description provided for @todayCuisineAndMinutes.
  ///
  /// In en, this message translates to:
  /// **'{cuisine} | {minutes} min'**
  String todayCuisineAndMinutes(String cuisine, int minutes);

  /// No description provided for @todayCurrentStrategyLabel.
  ///
  /// In en, this message translates to:
  /// **'Strategy: {strategy}'**
  String todayCurrentStrategyLabel(String strategy);

  /// No description provided for @todayDrawTodayMenu.
  ///
  /// In en, this message translates to:
  /// **'Draw Menu'**
  String get todayDrawTodayMenu;

  /// No description provided for @todayLocalCuisineLabel.
  ///
  /// In en, this message translates to:
  /// **'Local cuisine: {cuisine}'**
  String todayLocalCuisineLabel(String cuisine);

  /// No description provided for @todayLockedCannotReplace.
  ///
  /// In en, this message translates to:
  /// **'Locked dishes cannot be replaced.'**
  String get todayLockedCannotReplace;

  /// No description provided for @todayLogoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t log out: {error}'**
  String todayLogoutFailed(String error);

  /// No description provided for @todayMenuGenerateFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t generate menu: {error}'**
  String todayMenuGenerateFailed(String error);

  /// No description provided for @todayNoReplacementCandidates.
  ///
  /// In en, this message translates to:
  /// **'No replacement dishes available.'**
  String get todayNoReplacementCandidates;

  /// No description provided for @todayPatternDefault.
  ///
  /// In en, this message translates to:
  /// **'3 dishes + 1 soup'**
  String get todayPatternDefault;

  /// No description provided for @todayPreferredCuisineLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred cuisines: {cuisines}'**
  String todayPreferredCuisineLabel(String cuisines);

  /// No description provided for @todayPreviewCannotLogout.
  ///
  /// In en, this message translates to:
  /// **'Log out is disabled in preview mode.'**
  String get todayPreviewCannotLogout;

  /// No description provided for @todayReasonBasicMatch.
  ///
  /// In en, this message translates to:
  /// **'Base match'**
  String get todayReasonBasicMatch;

  /// No description provided for @todayReasonLocalCuisine.
  ///
  /// In en, this message translates to:
  /// **'Local cuisine'**
  String get todayReasonLocalCuisine;

  /// No description provided for @todayReasonPreferredCuisine.
  ///
  /// In en, this message translates to:
  /// **'Preferred cuisine'**
  String get todayReasonPreferredCuisine;

  /// No description provided for @todayReasonSameCity.
  ///
  /// In en, this message translates to:
  /// **'Same city'**
  String get todayReasonSameCity;

  /// No description provided for @todayReasonSameProvince.
  ///
  /// In en, this message translates to:
  /// **'Same province'**
  String get todayReasonSameProvince;

  /// No description provided for @todayReasonSeason.
  ///
  /// In en, this message translates to:
  /// **'In season'**
  String get todayReasonSeason;

  /// No description provided for @todayReasonTaste.
  ///
  /// In en, this message translates to:
  /// **'Taste match'**
  String get todayReasonTaste;

  /// No description provided for @todayReplaceFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t replace dish: {error}'**
  String todayReplaceFailed(String error);

  /// No description provided for @todayReplacedOneDish.
  ///
  /// In en, this message translates to:
  /// **'Dish replaced.'**
  String get todayReplacedOneDish;

  /// No description provided for @todaySeasonAndPattern.
  ///
  /// In en, this message translates to:
  /// **'Season: {season} | Pattern: {dishCount} dishes + {soupCount} soup'**
  String todaySeasonAndPattern(String season, int dishCount, int soupCount);

  /// No description provided for @todaySeasonAutumn.
  ///
  /// In en, this message translates to:
  /// **'Autumn'**
  String get todaySeasonAutumn;

  /// No description provided for @todaySeasonSpring.
  ///
  /// In en, this message translates to:
  /// **'Spring'**
  String get todaySeasonSpring;

  /// No description provided for @todaySeasonSummer.
  ///
  /// In en, this message translates to:
  /// **'Summer'**
  String get todaySeasonSummer;

  /// No description provided for @todaySeasonWinter.
  ///
  /// In en, this message translates to:
  /// **'Winter'**
  String get todaySeasonWinter;

  /// No description provided for @todayStrategyPreferenceLocalWeight.
  ///
  /// In en, this message translates to:
  /// **'Preference-first + local boost'**
  String get todayStrategyPreferenceLocalWeight;

  /// No description provided for @todayTitle.
  ///
  /// In en, this message translates to:
  /// **'Dinner Tarot'**
  String get todayTitle;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
