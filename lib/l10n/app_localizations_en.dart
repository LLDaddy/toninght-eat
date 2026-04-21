// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'What to Eat Tonight';

  @override
  String get commonDish => 'Dish';

  @override
  String get commonFavorites => 'Favorites';

  @override
  String get commonHome => 'Home';

  @override
  String get commonLock => 'Lock';

  @override
  String get commonLocked => 'Locked';

  @override
  String get commonMine => 'Me';

  @override
  String get commonRecipes => 'Recipes';

  @override
  String get commonRegenerate => 'Draw Again';

  @override
  String get commonReplaceThis => 'Replace Dish';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonSoup => 'Soup';

  @override
  String get commonUnselected => 'None';

  @override
  String get homePhase1Done => 'Phase 1 complete';

  @override
  String get loginInstruction => 'Enter your phone number to get a verification code.';

  @override
  String get loginOtpSent => 'Verification code sent.';

  @override
  String get loginPhoneHint => 'e.g. 13800138000 or +8613800138000';

  @override
  String get loginPhoneInvalid => 'Enter a valid phone number.';

  @override
  String get loginPhoneLabel => 'Phone Number';

  @override
  String get loginPhoneRequired => 'Please enter your phone number';

  @override
  String loginSendFailed(String error) {
    return 'Couldn\'t send code: $error';
  }

  @override
  String get loginSendOtp => 'Send Code';

  @override
  String get loginSending => 'Sending...';

  @override
  String get loginTitle => 'Log In with Phone';

  @override
  String get mainShellFavoritesTabPlaceholder => 'Favorites tab coming soon';

  @override
  String get mainShellLogoutTooltip => 'Log Out';

  @override
  String get mainShellMineTabPlaceholder => 'Profile tab coming soon';

  @override
  String get mainShellRecipesTabPlaceholder => 'Recipes tab coming soon';

  @override
  String get onboardingAdd => 'Add';

  @override
  String get onboardingCityLabel => 'City *';

  @override
  String get onboardingCityRequired => 'Please select a city';

  @override
  String get onboardingDislikedHint => 'Type ingredient';

  @override
  String get onboardingDislikedLabel => 'Disliked Ingredients (multi-select/input)';

  @override
  String get onboardingFamilySizeLabel => 'Family Members *';

  @override
  String get onboardingFamilySizeRangeInvalid => 'Enter a number between 1 and 20';

  @override
  String get onboardingFamilySizeRequired => 'Enter family size';

  @override
  String get onboardingMenuPatternLabel => 'Menu Pattern *';

  @override
  String get onboardingMenuPatternRequired => 'Please select a menu pattern';

  @override
  String get onboardingPreferredCuisinesLabel => 'Preferred Cuisines (multi-select)';

  @override
  String get onboardingProvinceLabel => 'Province *';

  @override
  String get onboardingProvinceRequired => 'Please select a province';

  @override
  String get onboardingRequiredFieldsIncomplete => 'Complete all required fields.';

  @override
  String get onboardingSave => 'Save Setup';

  @override
  String onboardingSaveFailed(String error) {
    return 'Couldn\'t save setup: $error';
  }

  @override
  String get onboardingSaveSuccess => 'Setup saved.';

  @override
  String get onboardingSaving => 'Saving...';

  @override
  String get onboardingSectionDisliked => 'Disliked Ingredients';

  @override
  String get onboardingSectionMenuPattern => 'Menu Pattern';

  @override
  String get onboardingSectionPreferences => 'Preferences';

  @override
  String get onboardingSectionRegionFamily => 'Location & Family';

  @override
  String get onboardingSessionExpired => 'Session expired. Please log in again.';

  @override
  String get onboardingTastePreferencesLabel => 'Taste Preferences *';

  @override
  String get onboardingTitle => 'First-Time Setup';

  @override
  String get otpCodeInvalid => 'Enter a 6-digit code.';

  @override
  String get otpCodeLabel => '6-digit code';

  @override
  String get otpCodeRequired => 'Enter the verification code.';

  @override
  String get otpLoginSuccess => 'Logged in successfully.';

  @override
  String otpSentTo(String phone) {
    return 'Code sent to $phone';
  }

  @override
  String get otpTitle => 'Enter Verification Code';

  @override
  String get otpVerifyAndLogin => 'Verify & Log In';

  @override
  String otpVerifyFailed(String error) {
    return 'Code is invalid or expired: $error';
  }

  @override
  String get otpVerifying => 'Verifying...';

  @override
  String get recipeDetailAddTodayMenuButton => 'Add to Today\'s Menu';

  @override
  String get recipeDetailAddTodayMenuPlaceholder => 'Add to menu coming soon';

  @override
  String get recipeDetailFavoriteButton => 'Save Recipe';

  @override
  String get recipeDetailFavoritePlaceholder => 'Favorites feature coming soon';

  @override
  String recipeDetailIngredientBullet(String ingredient) {
    return '- $ingredient';
  }

  @override
  String get recipeDetailIngredientsTitle => 'Ingredients';

  @override
  String get recipeDetailStepsTitle => 'Steps';

  @override
  String recipeDetailSummary(String type, String cuisine, int minutes) {
    return '$type | $cuisine | $minutes min';
  }

  @override
  String get recipeDetailTitle => 'Recipe Details';

  @override
  String get startupMissingEnv => 'Missing .env. Set it up from .env.example first.';

  @override
  String get startupMissingSupabaseKeys => 'Missing SUPABASE_URL or SUPABASE_ANON_KEY.';

  @override
  String tarotDrawFailed(String error) {
    return 'Couldn\'t draw menu: $error';
  }

  @override
  String get tarotDrawTodayMenuButton => 'Draw Menu';

  @override
  String get tarotDrawingButton => 'Drawing...';

  @override
  String get tarotDrawingHint => 'Shuffling cards and revealing menu...';

  @override
  String get tarotPhaseDrawing => 'Drawing';

  @override
  String get tarotPhaseIdle => 'Ready to Draw';

  @override
  String get tarotPhaseResult => 'Menu Revealed';

  @override
  String get tarotReadyHint => 'Tap Draw to reveal today\'s menu.';

  @override
  String get tarotRedraw => 'Draw Again';

  @override
  String tarotResultLine(String name, String type, int minutes) {
    return '$name | $type | $minutes min';
  }

  @override
  String get tarotResultTitle => 'Today\'s Menu';

  @override
  String get tarotTitle => 'Dinner Tarot';

  @override
  String get tarotUseThisMenu => 'Use Menu';

  @override
  String todayCuisineAndMinutes(String cuisine, int minutes) {
    return '$cuisine | $minutes min';
  }

  @override
  String todayCurrentStrategyLabel(String strategy) {
    return 'Strategy: $strategy';
  }

  @override
  String get todayDrawTodayMenu => 'Draw Menu';

  @override
  String todayLocalCuisineLabel(String cuisine) {
    return 'Local cuisine: $cuisine';
  }

  @override
  String get todayLockedCannotReplace => 'Locked dishes cannot be replaced.';

  @override
  String todayLogoutFailed(String error) {
    return 'Couldn\'t log out: $error';
  }

  @override
  String todayMenuGenerateFailed(String error) {
    return 'Couldn\'t generate menu: $error';
  }

  @override
  String get todayNoReplacementCandidates => 'No replacement dishes available.';

  @override
  String get todayPatternDefault => '3 dishes + 1 soup';

  @override
  String todayPreferredCuisineLabel(String cuisines) {
    return 'Preferred cuisines: $cuisines';
  }

  @override
  String get todayPreviewCannotLogout => 'Log out is disabled in preview mode.';

  @override
  String get todayReasonBasicMatch => 'Base match';

  @override
  String get todayReasonLocalCuisine => 'Local cuisine';

  @override
  String get todayReasonPreferredCuisine => 'Preferred cuisine';

  @override
  String get todayReasonSameCity => 'Same city';

  @override
  String get todayReasonSameProvince => 'Same province';

  @override
  String get todayReasonSeason => 'In season';

  @override
  String get todayReasonTaste => 'Taste match';

  @override
  String todayReplaceFailed(String error) {
    return 'Couldn\'t replace dish: $error';
  }

  @override
  String get todayReplacedOneDish => 'Dish replaced.';

  @override
  String todaySeasonAndPattern(String season, int dishCount, int soupCount) {
    return 'Season: $season | Pattern: $dishCount dishes + $soupCount soup';
  }

  @override
  String get todaySeasonAutumn => 'Autumn';

  @override
  String get todaySeasonSpring => 'Spring';

  @override
  String get todaySeasonSummer => 'Summer';

  @override
  String get todaySeasonWinter => 'Winter';

  @override
  String get todayStrategyPreferenceLocalWeight => 'Preference-first + local boost';

  @override
  String get todayTitle => 'Dinner Tarot';
}
