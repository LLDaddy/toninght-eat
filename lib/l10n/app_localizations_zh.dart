// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '今晚吃什么';

  @override
  String get commonDish => '菜';

  @override
  String get commonFavorites => '收藏';

  @override
  String get commonHome => '首页';

  @override
  String get commonLock => '锁定';

  @override
  String get commonLocked => '已锁定';

  @override
  String get commonMine => '我的';

  @override
  String get commonRecipes => '菜谱';

  @override
  String get commonRegenerate => '重新生成';

  @override
  String get commonReplaceThis => '替换这道';

  @override
  String get commonRetry => '重试';

  @override
  String get commonSoup => '汤';

  @override
  String get commonUnselected => '未选择';

  @override
  String get homePhase1Done => 'Phase 1完成';

  @override
  String get loginInstruction => '请输入手机号获取验证码';

  @override
  String get loginOtpSent => '验证码已发送';

  @override
  String get loginPhoneHint => '如 13800138000 或 +8613800138000';

  @override
  String get loginPhoneInvalid => '手机号格式不正确';

  @override
  String get loginPhoneLabel => '手机号';

  @override
  String get loginPhoneRequired => '请输入手机号';

  @override
  String loginSendFailed(String error) {
    return '发送失败: $error';
  }

  @override
  String get loginSendOtp => '发送验证码';

  @override
  String get loginSending => '发送中...';

  @override
  String get loginTitle => '手机号登录';

  @override
  String get mainShellFavoritesTabPlaceholder => '收藏页骨架已就位';

  @override
  String get mainShellLogoutTooltip => '退出登录';

  @override
  String get mainShellMineTabPlaceholder => '我的页骨架已就位';

  @override
  String get mainShellRecipesTabPlaceholder => '菜谱页骨架已就位';

  @override
  String get recipesSearchLabel => '搜索菜谱';

  @override
  String get recipesSearchHint => '按菜名、菜系或口味搜索';

  @override
  String get recipesFilterAll => '全部';

  @override
  String recipesCount(int count) {
    return '共 $count 道菜';
  }

  @override
  String get recipesEmpty => '没有匹配当前筛选条件的菜谱';

  @override
  String get recipesClearFilters => '清空筛选';

  @override
  String recipesLoadFailed(String error) {
    return '加载菜谱失败: $error';
  }

  @override
  String get onboardingAdd => '添加';

  @override
  String get onboardingCityLabel => '市 *';

  @override
  String get onboardingCityRequired => '请选择城市';

  @override
  String get onboardingDislikedHint => '输入后点击添加，如 香菜';

  @override
  String get onboardingDislikedLabel => '忌口（可多选/输入）';

  @override
  String get onboardingFamilySizeLabel => '家庭成员数 *';

  @override
  String get onboardingFamilySizeRangeInvalid => '请输入 1-20 的数字';

  @override
  String get onboardingFamilySizeRequired => '请输入家庭成员数';

  @override
  String get onboardingMenuPatternLabel => '菜单结构 *';

  @override
  String get onboardingMenuPatternRequired => '请选择菜单结构';

  @override
  String get onboardingPreferredCuisinesLabel => '偏好菜系（可多选）';

  @override
  String get onboardingProvinceLabel => '省 *';

  @override
  String get onboardingProvinceRequired => '请选择省份';

  @override
  String get onboardingRequiredFieldsIncomplete => '请完成所有必填项';

  @override
  String get onboardingSave => '保存配置';

  @override
  String onboardingSaveFailed(String error) {
    return '保存失败: $error';
  }

  @override
  String get onboardingSaveSuccess => '配置保存成功';

  @override
  String get onboardingSaving => '保存中...';

  @override
  String get onboardingSectionDisliked => '忌口设置';

  @override
  String get onboardingSectionMenuPattern => '菜单结构';

  @override
  String get onboardingSectionPreferences => '偏好设置';

  @override
  String get onboardingSectionRegionFamily => '地区与家庭';

  @override
  String get onboardingSessionExpired => '登录状态失效，请重新登录';

  @override
  String get onboardingTastePreferencesLabel => '口味偏好 *';

  @override
  String get onboardingTitle => '首次配置';

  @override
  String get otpCodeInvalid => '请输入6位数字';

  @override
  String get otpCodeLabel => '6位验证码';

  @override
  String get otpCodeRequired => '请输入验证码';

  @override
  String get otpLoginSuccess => '登录成功';

  @override
  String otpSentTo(String phone) {
    return '验证码已发送到 $phone';
  }

  @override
  String get otpTitle => '输入验证码';

  @override
  String get otpVerifyAndLogin => '验证并登录';

  @override
  String otpVerifyFailed(String error) {
    return '验证码错误或已过期: $error';
  }

  @override
  String get otpVerifying => '验证中...';

  @override
  String get recipeDetailAddTodayMenuButton => '加入今日菜单';

  @override
  String get recipeDetailAddTodayMenuPlaceholder => '加入今日菜单占位，后续接入';

  @override
  String get recipeDetailFavoriteButton => '收藏';

  @override
  String get recipeDetailFavoritePlaceholder => '收藏功能占位，后续接入';

  @override
  String recipeDetailIngredientBullet(String ingredient) {
    return '· $ingredient';
  }

  @override
  String get recipeDetailIngredientsTitle => '食材清单';

  @override
  String get recipeDetailStepsTitle => '做法步骤';

  @override
  String recipeDetailSummary(String type, String cuisine, int minutes) {
    return '类型: $type · 菜系: $cuisine · 耗时: $minutes分钟';
  }

  @override
  String get recipeDetailTitle => '菜谱详情';

  @override
  String get startupMissingEnv => '未找到 .env，请先按 .env.example 配置';

  @override
  String get startupMissingSupabaseKeys => '缺少 SUPABASE_URL 或 SUPABASE_ANON_KEY';

  @override
  String tarotDrawFailed(String error) {
    return '抽取失败: $error';
  }

  @override
  String get tarotDrawTodayMenuButton => '抽取今日菜单';

  @override
  String get tarotDrawingButton => '抽取中...';

  @override
  String get tarotDrawingHint => '正在洗牌与揭示...';

  @override
  String get tarotPhaseDrawing => '抽取中';

  @override
  String get tarotPhaseIdle => '未抽取';

  @override
  String get tarotPhaseResult => '已揭示';

  @override
  String get tarotReadyHint => '准备好后开始抽卡，揭示今日菜单';

  @override
  String get tarotRedraw => '重新抽取';

  @override
  String tarotResultLine(String name, String type, int minutes) {
    return '$name · $type · $minutes分钟';
  }

  @override
  String get tarotResultTitle => '抽取结果';

  @override
  String get tarotTitle => '今日吃什么？';

  @override
  String get tarotUseThisMenu => '使用这份菜单';

  @override
  String todayCuisineAndMinutes(String cuisine, int minutes) {
    return '$cuisine · $minutes分钟';
  }

  @override
  String todayCurrentStrategyLabel(String strategy) {
    return '当前推荐策略: $strategy';
  }

  @override
  String get todayDrawTodayMenu => '抽取今日菜单';

  @override
  String todayLocalCuisineLabel(String cuisine) {
    return '本地菜系: $cuisine';
  }

  @override
  String get todayLockedCannotReplace => '已锁定，无法替换';

  @override
  String todayLogoutFailed(String error) {
    return '退出失败: $error';
  }

  @override
  String todayMenuGenerateFailed(String error) {
    return '菜单生成失败: $error';
  }

  @override
  String get todayNoReplacementCandidates => '暂无可替换候选';

  @override
  String get todayPatternDefault => '3菜1汤';

  @override
  String todayPreferredCuisineLabel(String cuisines) {
    return '偏好菜系: $cuisines';
  }

  @override
  String get todayPreviewCannotLogout => '预览模式不可退出';

  @override
  String get todayReasonBasicMatch => '基础匹配';

  @override
  String get todayReasonLocalCuisine => '命中本地菜系';

  @override
  String get todayReasonPreferredCuisine => '命中偏好菜系';

  @override
  String get todayReasonSameCity => '同市';

  @override
  String get todayReasonSameProvince => '同省';

  @override
  String get todayReasonSeason => '命中当季';

  @override
  String get todayReasonTaste => '命中口味';

  @override
  String todayReplaceFailed(String error) {
    return '替换失败: $error';
  }

  @override
  String get todayReplacedOneDish => '已替换一道菜';

  @override
  String todaySeasonAndPattern(String season, int dishCount, int soupCount) {
    return '当季: $season · 结构: $dishCount菜$soupCount汤';
  }

  @override
  String get todaySeasonAutumn => '秋';

  @override
  String get todaySeasonSpring => '春';

  @override
  String get todaySeasonSummer => '夏';

  @override
  String get todaySeasonWinter => '冬';

  @override
  String get todayStrategyPreferenceLocalWeight => '偏好优先+本地加权';

  @override
  String get todayTitle => '今日吃什么？';
}
