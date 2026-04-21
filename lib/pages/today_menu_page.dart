import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../l10n/l10n_ext.dart';
import '../models/menu_generation_result.dart';
import '../models/recipe.dart';
import '../models/user_profile.dart';
import '../services/menu_engine_service.dart';
import '../ui/app_tokens.dart';
import '../ui/components/metal_action_button.dart';
import '../ui/components/primary_button.dart';
import '../ui/components/ritual_tarot_ring.dart';
import '../ui/components/section_card.dart';
import 'recipe_detail_page.dart';
import 'tarot_draw_page.dart';

class TodayMenuController {
  VoidCallback? _logoutHandler;

  void bindLogout(VoidCallback handler) => _logoutHandler = handler;

  void unbindLogout(VoidCallback handler) {
    if (_logoutHandler == handler) {
      _logoutHandler = null;
    }
  }

  void logout() => _logoutHandler?.call();
}

class TodayMenuPage extends StatefulWidget {
  const TodayMenuPage({
    super.key,
    required this.profile,
    this.embedded = false,
    this.controller,
  });

  final UserProfile profile;
  final bool embedded;
  final TodayMenuController? controller;

  @override
  State<TodayMenuPage> createState() => _TodayMenuPageState();
}

class _TodayMenuPageState extends State<TodayMenuPage> {
  static const _previewMode = bool.fromEnvironment('HOME_UI_PREVIEW');

  final MenuEngineService _engine = MenuEngineService();
  MenuGenerationResult? _result;
  List<RecommendedMenuItem> _items = <RecommendedMenuItem>[];
  final Set<int> _locked = <int>{};

  bool _loading = true;
  bool _refreshing = false;
  bool _replacing = false;
  String? _error;
  bool _didInitialLoad = false;

  int _refreshNonce = 0;
  int _replaceNonce = 0;

  @override
  void initState() {
    super.initState();
    widget.controller?.bindLogout(_logout);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInitialLoad) return;
    _didInitialLoad = true;
    _loadMenu(initial: true);
  }

  @override
  void didUpdateWidget(covariant TodayMenuPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.unbindLogout(_logout);
      widget.controller?.bindLogout(_logout);
    }
  }

  @override
  void dispose() {
    widget.controller?.unbindLogout(_logout);
    super.dispose();
  }

  Future<void> _loadMenu({required bool initial}) async {
    if (initial) {
      setState(() {
        _loading = true;
        _error = null;
      });
    } else {
      setState(() => _refreshing = true);
    }

    final nextNonce = initial ? _refreshNonce : _refreshNonce + 1;
    try {
      final result = _previewMode
          ? _buildPreviewMenu(nextNonce)
          : await _engine.generateTodayMenu(
              widget.profile,
              refreshNonce: nextNonce,
            );
      if (!mounted) return;
      setState(() {
        _refreshNonce = nextNonce;
        _result = result;
        _items = List<RecommendedMenuItem>.from(result.selectedItems);
        _locked.clear();
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(
          () => _error = context.l10n.todayMenuGenerateFailed(e.toString()));
      _showSnack(_error!);
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
          _refreshing = false;
        });
      }
    }
  }

  void _toggleLock(int recipeId) {
    setState(() {
      if (_locked.contains(recipeId)) {
        _locked.remove(recipeId);
      } else {
        _locked.add(recipeId);
      }
    });
  }

  Future<void> _replaceOne(RecommendedMenuItem item) async {
    final l10n = context.l10n;
    if (_locked.contains(item.recipe.id)) {
      _showSnack(l10n.todayLockedCannotReplace);
      return;
    }
    if (_replacing) return;

    setState(() => _replacing = true);
    try {
      if (_previewMode) {
        final updated = _replaceOnePreview(item.recipe.id);
        if (updated == null) {
          _showSnack(l10n.todayNoReplacementCandidates);
        } else {
          setState(() {
            _replaceNonce += 1;
            _items = updated;
          });
          _showSnack(l10n.todayReplacedOneDish);
        }
      } else {
        final result = await _engine.replaceSingleMenuItem(
          profile: widget.profile,
          currentItems: _items,
          targetRecipeId: item.recipe.id,
          lockedRecipeIds: _locked,
          refreshNonce: _refreshNonce,
          replaceNonce: _replaceNonce + 1,
        );
        _showSnack(result.message);
        if (result.success && result.updatedItems != null) {
          setState(() {
            _replaceNonce += 1;
            _items = List<RecommendedMenuItem>.from(result.updatedItems!);
          });
        }
      }
    } catch (e) {
      _showSnack(l10n.todayReplaceFailed(e.toString()));
    } finally {
      if (mounted) {
        setState(() => _replacing = false);
      }
    }
  }

  Future<void> _logout() async {
    final l10n = context.l10n;
    if (_previewMode) {
      _showSnack(l10n.todayPreviewCannotLogout);
      return;
    }
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (e) {
      _showSnack(l10n.todayLogoutFailed(e.toString()));
    }
  }

  void _showSnack(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<MenuGenerationResult> _generateMenuForDraw(int refreshNonce) async {
    if (_previewMode) {
      return _buildPreviewMenu(refreshNonce);
    }
    return _engine.generateTodayMenu(
      widget.profile,
      refreshNonce: refreshNonce,
    );
  }

  Future<void> _openTarotDraw() async {
    if (_refreshing || _replacing) return;
    setState(() => _refreshing = true);

    final drawResult = await Navigator.of(context).push<TarotDrawResult>(
      MaterialPageRoute(
        builder: (_) => TarotDrawPage(
          profile: widget.profile,
          baseRefreshNonce: _refreshNonce,
          generateMenu: _generateMenuForDraw,
        ),
      ),
    );

    if (!mounted) return;
    setState(() => _refreshing = false);

    if (drawResult == null) {
      return;
    }

    setState(() {
      _refreshNonce = drawResult.refreshNonce;
      _result = drawResult.menuResult;
      _items =
          List<RecommendedMenuItem>.from(drawResult.menuResult.selectedItems);
      _locked.clear();
      _replaceNonce = 0;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/images/kitchen_scene_bg.png',
              fit: BoxFit.cover),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.58),
                  Colors.black.withValues(alpha: 0.26),
                  Colors.black.withValues(alpha: 0.46),
                ],
                stops: const [0, 0.45, 1],
              ),
            ),
          ),
        ),
        const Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.2),
                  radius: 0.95,
                  colors: [
                    Color(0x40FFAF53),
                    Color(0x16FF8A2E),
                    Colors.transparent
                  ],
                  stops: [0, 0.52, 1],
                ),
              ),
            ),
          ),
        ),
        const Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0x78D55A16),
                    Color(0x1FD56A1E),
                    Colors.transparent
                  ],
                  stops: [0, 0.3, 0.58],
                ),
              ),
            ),
          ),
        ),
        SafeArea(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null && _result == null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: SectionCard(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(_error!, textAlign: TextAlign.center),
                              const SizedBox(height: AppSpacing.md),
                              PrimaryButton(
                                label: context.l10n.commonRetry,
                                onPressed: () => _loadMenu(initial: true),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : _buildContent(),
        ),
      ],
    );
  }

  Widget _buildContent() {
    final result = _result!;
    return LayoutBuilder(
      builder: (context, c) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: c.maxHeight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                  child: Column(
                    children: [
                      _buildTitle(),
                      const SizedBox(height: 14),
                      _buildTarot(),
                      const Spacer(),
                      _buildCta(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: _buildMeta(result),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: _buildCards(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        height: 72,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Align(
              alignment: Alignment(-1, 0),
              child: _TitleWing(),
            ),
            const Align(
              alignment: Alignment(1, 0),
              child: _TitleWing(reverse: true),
            ),
            Center(
              child: Text(
                context.l10n.todayTitle,
                maxLines: 1,
                softWrap: false,
                style: const TextStyle(
                  color: Color(0xFFF8D184),
                  fontSize: 51,
                  fontWeight: FontWeight.w900,
                  shadows: [
                    Shadow(
                        color: Color(0xC021130A),
                        blurRadius: 9,
                        offset: Offset(0, 3))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTarot() {
    return SizedBox(
      height: 360,
      child: Center(
        child: const RitualTarotRing(),
      ),
    );
  }

  Widget _buildCta() {
    final disabled = _refreshing || _replacing;
    return MetalActionButton(
      label: context.l10n.todayDrawTodayMenu,
      onPressed: disabled ? null : _openTarotDraw,
      fontSize: 30,
      horizontalPadding: 36,
    );
  }

  Widget _buildMeta(MenuGenerationResult result) {
    final preferred = result.preferredCuisines.isEmpty
        ? context.l10n.commonUnselected
        : result.preferredCuisines.join('、');
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.todayLocalCuisineLabel(result.localCuisine),
              style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(context.l10n.todayPreferredCuisineLabel(preferred)),
          const SizedBox(height: 6),
          Text(context.l10n.todayCurrentStrategyLabel(
            _displayStrategy(result.strategy),
          )),
          const SizedBox(height: 6),
          Text(context.l10n.todaySeasonAndPattern(
            _seasonLabel(result.season),
            result.dishTarget,
            result.soupTarget,
          )),
        ],
      ),
    );
  }

  Widget _buildCards() {
    if (_items.isEmpty) {
      return SectionCard(
        child: PrimaryButton(
          label: context.l10n.commonRegenerate,
          onPressed: () => _loadMenu(initial: true),
        ),
      );
    }

    return Column(
      children: _items.map((item) {
        final locked = _locked.contains(item.recipe.id);
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SectionCard(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.md),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => RecipeDetailPage(recipe: item.recipe)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.recipe.name,
                              style: const TextStyle(
                                  fontSize: AppTextSize.lg,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          _TypeTag(type: item.recipe.courseType),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                          context.l10n.todayCuisineAndMinutes(
                            item.recipe.cuisine,
                            item.recipe.cookMinutes,
                          ),
                          style:
                              const TextStyle(color: AppColors.textSecondary)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: item.reasons.map((reason) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.inputFill,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.borderSoft),
                            ),
                            child: Text(_displayReason(reason),
                                style: const TextStyle(fontSize: 12)),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => _toggleLock(item.recipe.id),
                            icon: Icon(locked ? Icons.lock : Icons.lock_open,
                                size: 18),
                            label: Text(locked
                                ? context.l10n.commonLocked
                                : context.l10n.commonLock),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: PrimaryButton(
                              label: context.l10n.commonReplaceThis,
                              icon: const Icon(Icons.autorenew),
                              expanded: true,
                              onPressed: (locked || _replacing)
                                  ? null
                                  : () => _replaceOne(item),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  MenuGenerationResult _buildPreviewMenu(int refreshNonce) {
    final season = _monthToSeason(DateTime.now().month);
    final pattern = _parsePattern(widget.profile.menuPattern);
    final dailySeed = _dailySeed(widget.profile.id, refreshNonce);
    final preferred = widget.profile.effectivePreferredCuisines;
    final local = widget.profile.localCuisine;

    final scored = _previewRecipes
        .map((recipe) =>
            _scorePreview(recipe, season, preferred, local, dailySeed))
        .toList()
      ..sort((a, b) {
        if (b.score != a.score) return b.score.compareTo(a.score);
        if (a.tie != b.tie) return a.tie.compareTo(b.tie);
        return a.recipe.id.compareTo(b.recipe.id);
      });

    final dishes = _pickPreview(
      scored.where((e) => e.recipe.isDish).toList(),
      pattern.dish,
      dailySeed,
      refreshNonce,
      17,
    );
    final soups = _pickPreview(
      scored.where((e) => e.recipe.isSoup).toList(),
      pattern.soup,
      dailySeed,
      refreshNonce,
      31,
    );

    return MenuGenerationResult(
      selectedItems: [
        ...dishes.map((e) => e.toItem()),
        ...soups.map((e) => e.toItem()),
      ],
      strategy: context.l10n.todayStrategyPreferenceLocalWeight,
      season: season,
      dishTarget: pattern.dish,
      soupTarget: pattern.soup,
      localCuisine: local,
      preferredCuisines: preferred,
      relaxed: false,
    );
  }

  _Scored _scorePreview(
    Recipe recipe,
    String season,
    List<String> preferred,
    String local,
    int dailySeed,
  ) {
    var score = 0;
    final reasons = <String>[];

    if (preferred.contains(recipe.cuisine)) {
      score += 45;
      reasons.add(context.l10n.todayReasonPreferredCuisine);
    }
    if (recipe.cuisine == local) {
      score += 25;
      reasons.add(context.l10n.todayReasonLocalCuisine);
    }

    var tasteHit = 0;
    for (final taste in widget.profile.tastePrefs) {
      if (recipe.tasteTags.contains(taste)) tasteHit += 1;
    }
    if (tasteHit > 0) {
      score += math.min(tasteHit, 2) * 12;
      reasons.add(context.l10n.todayReasonTaste);
    }

    if (recipe.seasons.contains(season)) {
      score += 18;
      reasons.add(context.l10n.todayReasonSeason);
    }

    if (widget.profile.province != null &&
        widget.profile.province == recipe.province) {
      score += 8;
      reasons.add(context.l10n.todayReasonSameProvince);
    }
    if (widget.profile.city != null && widget.profile.city == recipe.city) {
      score += 12;
      reasons.add(context.l10n.todayReasonSameCity);
    }

    if (reasons.isEmpty) {
      reasons.add(context.l10n.todayReasonBasicMatch);
    }

    return _Scored(
      recipe: recipe,
      score: score,
      reasons: reasons,
      tie: _stableTie(recipe.id, dailySeed),
    );
  }

  List<_Scored> _pickPreview(
    List<_Scored> pool,
    int count,
    int dailySeed,
    int refreshNonce,
    int salt,
  ) {
    if (count <= 0 || pool.isEmpty) return const <_Scored>[];
    if (pool.length <= count || refreshNonce == 0) {
      return pool.take(math.min(count, pool.length)).toList();
    }
    final window = math.min(pool.length, math.max(count * 3, count + 2));
    final maxOffset = window - count;
    if (maxOffset <= 0) {
      return pool.take(math.min(count, pool.length)).toList();
    }
    final base =
        ((dailySeed ^ (salt * 2654435761)) & 0x7fffffff) % (maxOffset + 1);
    final offset = (base + refreshNonce) % (maxOffset + 1);
    return pool.skip(offset).take(count).toList();
  }

  List<RecommendedMenuItem>? _replaceOnePreview(int targetRecipeId) {
    final index = _items.indexWhere((e) => e.recipe.id == targetRecipeId);
    if (index < 0) return null;

    final target = _items[index];
    final season = _monthToSeason(DateTime.now().month);
    final seed =
        _dailySeed(widget.profile.id, _refreshNonce + _replaceNonce + 97);
    final existing = _items.map((e) => e.recipe.id).toSet();

    final candidates = _previewRecipes
        .map((recipe) => _scorePreview(
              recipe,
              season,
              widget.profile.effectivePreferredCuisines,
              widget.profile.localCuisine,
              seed,
            ))
        .where((e) =>
            e.recipe.courseType == target.recipe.courseType &&
            !existing.contains(e.recipe.id))
        .toList()
      ..sort((a, b) {
        if (b.score != a.score) return b.score.compareTo(a.score);
        if (a.tie != b.tie) return a.tie.compareTo(b.tie);
        return a.recipe.id.compareTo(b.recipe.id);
      });

    if (candidates.isEmpty) return null;
    final window = math.min(6, candidates.length);
    final idx = ((seed ^ ((_replaceNonce + 1) * 104729)) & 0x7fffffff) % window;

    final updated = List<RecommendedMenuItem>.from(_items);
    updated[index] = candidates[idx].toItem();
    return updated;
  }

  _Pattern _parsePattern(String? raw) {
    final text = raw ?? context.l10n.todayPatternDefault;
    final list = RegExp(r'\d+')
        .allMatches(text)
        .map((m) => int.parse(m.group(0)!))
        .toList();
    if (list.length >= 2) {
      return _Pattern(list[0], list[1]);
    }
    return const _Pattern(3, 1);
  }

  String _monthToSeason(int m) {
    if (m >= 3 && m <= 5) return 'spring';
    if (m >= 6 && m <= 8) return 'summer';
    if (m >= 9 && m <= 11) return 'autumn';
    return 'winter';
  }

  String _seasonLabel(String season) {
    switch (season) {
      case 'spring':
        return context.l10n.todaySeasonSpring;
      case 'summer':
        return context.l10n.todaySeasonSummer;
      case 'autumn':
        return context.l10n.todaySeasonAutumn;
      case 'winter':
        return context.l10n.todaySeasonWinter;
      default:
        return season;
    }
  }

  String _displayStrategy(String strategy) {
    if (strategy == '偏好优先+本地加权') {
      return context.l10n.todayStrategyPreferenceLocalWeight;
    }
    return strategy;
  }

  String _displayReason(String reason) {
    switch (reason) {
      case '命中偏好菜系':
        return context.l10n.todayReasonPreferredCuisine;
      case '命中本地菜系':
        return context.l10n.todayReasonLocalCuisine;
      case '命中口味':
        return context.l10n.todayReasonTaste;
      case '命中当季':
        return context.l10n.todayReasonSeason;
      case '同省':
        return context.l10n.todayReasonSameProvince;
      case '同市':
        return context.l10n.todayReasonSameCity;
      case '基础匹配':
        return context.l10n.todayReasonBasicMatch;
      default:
        return reason;
    }
  }

  int _dailySeed(String userId, int refreshNonce) {
    final now = DateTime.now();
    final dayCode = now.year * 10000 + now.month * 100 + now.day;
    return userId.hashCode ^ dayCode ^ (refreshNonce * 7919);
  }

  int _stableTie(int recipeId, int seed) {
    final mixed = recipeId * 1103515245 + seed * 12345;
    return mixed & 0x7fffffff;
  }
}

class _TitleWing extends StatelessWidget {
  const _TitleWing({this.reverse = false});

  final bool reverse;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scaleX: reverse ? -1 : 1,
      child: Row(
        children: [
          Container(
            width: 22,
            height: 2,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0x00F4C064), Color(0xFFF4C064)]),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 3),
          const Icon(Icons.star_rounded, size: 14, color: Color(0xFFECC677)),
          const SizedBox(width: 3),
          Container(width: 10, height: 1.4, color: const Color(0xFFF0C267)),
        ],
      ),
    );
  }
}

class _TypeTag extends StatelessWidget {
  const _TypeTag({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final isSoup = type == 'soup';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isSoup ? const Color(0x334CC8E7) : const Color(0x33F3A530),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Text(
        isSoup ? context.l10n.commonSoup : context.l10n.commonDish,
        style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
      ),
    );
  }
}

class _Scored {
  const _Scored({
    required this.recipe,
    required this.score,
    required this.reasons,
    required this.tie,
  });

  final Recipe recipe;
  final int score;
  final List<String> reasons;
  final int tie;

  RecommendedMenuItem toItem() =>
      RecommendedMenuItem(recipe: recipe, score: score, reasons: reasons);
}

class _Pattern {
  const _Pattern(this.dish, this.soup);

  final int dish;
  final int soup;
}

const List<Recipe> _previewRecipes = [
  Recipe(
      id: 9001,
      name: '葡萄井虾仁',
      cuisine: '江浙菜',
      region: '华东',
      province: '浙江',
      city: '宁波',
      seasons: ['spring', 'summer'],
      tasteTags: ['鲜香', '清淡'],
      courseType: 'dish',
      cookMinutes: 20),
  Recipe(
      id: 9002,
      name: '宁波烤菜芯',
      cuisine: '江浙菜',
      region: '华东',
      province: '浙江',
      city: '宁波',
      seasons: ['autumn', 'winter'],
      tasteTags: ['咸鲜'],
      courseType: 'dish',
      cookMinutes: 18),
  Recipe(
      id: 9003,
      name: '瓦罐牛肉',
      cuisine: '江西菜',
      region: '华中',
      province: '江西',
      city: '南昌',
      seasons: ['winter'],
      tasteTags: ['鲜辣', '重口'],
      courseType: 'dish',
      cookMinutes: 45),
  Recipe(
      id: 9004,
      name: '香辣粉丝虾',
      cuisine: '江浙菜',
      region: '华东',
      province: '浙江',
      city: '杭州',
      seasons: ['summer', 'autumn'],
      tasteTags: ['鲜香'],
      courseType: 'dish',
      cookMinutes: 22),
  Recipe(
      id: 9005,
      name: '鄂东辣子鸡',
      cuisine: '江西菜',
      region: '华中',
      province: '江西',
      city: '赣州',
      seasons: ['summer', 'autumn'],
      tasteTags: ['香辣', '重口'],
      courseType: 'dish',
      cookMinutes: 34),
  Recipe(
      id: 9006,
      name: '榨菜肉丝',
      cuisine: '江浙菜',
      region: '华东',
      province: '浙江',
      city: '宁波',
      seasons: ['winter', 'spring'],
      tasteTags: ['清淡', '鲜香'],
      courseType: 'dish',
      cookMinutes: 16),
  Recipe(
      id: 9007,
      name: '米酒红烧鱼',
      cuisine: '江西菜',
      region: '华中',
      province: '江西',
      city: '南昌',
      seasons: ['spring', 'summer'],
      tasteTags: ['鲜辣', '咸鲜'],
      courseType: 'dish',
      cookMinutes: 33),
  Recipe(
      id: 9008,
      name: '三鲜菌菇锅',
      cuisine: '江浙菜',
      region: '华东',
      province: '浙江',
      city: '杭州',
      seasons: ['autumn'],
      tasteTags: ['鲜香'],
      courseType: 'dish',
      cookMinutes: 24),
  Recipe(
      id: 9009,
      name: '藕带排骨汤',
      cuisine: '江浙菜',
      region: '华东',
      province: '浙江',
      city: '宁波',
      seasons: ['spring', 'winter'],
      tasteTags: ['鲜香'],
      courseType: 'soup',
      cookMinutes: 55),
  Recipe(
      id: 9010,
      name: '瓦罐鸡汤',
      cuisine: '江西菜',
      region: '华中',
      province: '江西',
      city: '南昌',
      seasons: ['autumn', 'winter'],
      tasteTags: ['鲜香'],
      courseType: 'soup',
      cookMinutes: 60),
  Recipe(
      id: 9011,
      name: '鲜笋咸肉汤',
      cuisine: '江浙菜',
      region: '华东',
      province: '浙江',
      city: '绍兴',
      seasons: ['spring'],
      tasteTags: ['咸鲜'],
      courseType: 'soup',
      cookMinutes: 36),
  Recipe(
      id: 9012,
      name: '柴火菌菇汤',
      cuisine: '江西菜',
      region: '华中',
      province: '江西',
      city: '南昌',
      seasons: ['spring', 'autumn'],
      tasteTags: ['鲜香'],
      courseType: 'soup',
      cookMinutes: 45),
];
