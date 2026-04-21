import 'dart:math';

import '../models/menu_generation_result.dart';
import '../models/recipe.dart';
import '../models/user_profile.dart';
import 'recipe_service.dart';

class MenuEngineService {
  MenuEngineService({RecipeService? recipeService})
      : _recipeService = recipeService ?? RecipeService();

  final RecipeService _recipeService;

  Future<MenuGenerationResult> generateTodayMenu(
    UserProfile profile, {
    int refreshNonce = 0,
  }) async {
    final recipes = await _recipeService.fetchActiveRecipes();
    final season = _monthToSeason(DateTime.now().month);
    final pattern = _parseMenuPattern(profile.menuPattern ?? '2菜1汤');
    final preferredCuisines = profile.effectivePreferredCuisines;
    final localCuisine = profile.localCuisine;
    final dailySeed = _dailySeed(profile.id, refreshNonce);

    final scored = recipes
        .map((recipe) => _scoreRecipe(
              recipe: recipe,
              profile: profile,
              preferredCuisines: preferredCuisines,
              localCuisine: localCuisine,
              season: season,
              tieBreaker: _stableTieBreaker(recipe.id, dailySeed),
            ))
        .toList()
      ..sort((a, b) {
        if (b.score != a.score) return b.score.compareTo(a.score);
        if (a.tieBreaker != b.tieBreaker) {
          return a.tieBreaker.compareTo(b.tieBreaker);
        }
        return a.recipe.id.compareTo(b.recipe.id);
      });

    final dishPool = scored.where((item) => item.recipe.isDish).toList();
    final soupPool = scored.where((item) => item.recipe.isSoup).toList();
    final selectedDishes = _pickWithinTopWindow(
      pool: dishPool,
      count: pattern.dishCount,
      dailySeed: dailySeed,
      refreshNonce: refreshNonce,
      salt: 17,
    );
    final selectedSoups = _pickWithinTopWindow(
      pool: soupPool,
      count: pattern.soupCount,
      dailySeed: dailySeed,
      refreshNonce: refreshNonce,
      salt: 31,
    );

    final selected = <RecommendedMenuItem>[
      ...selectedDishes.map((item) => item.toMenuItem()),
      ...selectedSoups.map((item) => item.toMenuItem()),
    ];

    final relaxed =
        dishPool.length < pattern.dishCount || soupPool.length < pattern.soupCount;

    return MenuGenerationResult(
      selectedItems: selected,
      strategy: '偏好优先+本地加权',
      season: season,
      dishTarget: pattern.dishCount,
      soupTarget: pattern.soupCount,
      localCuisine: localCuisine,
      preferredCuisines: preferredCuisines,
      relaxed: relaxed,
    );
  }

  Future<ReplaceSingleItemResult> replaceSingleMenuItem({
    required UserProfile profile,
    required List<RecommendedMenuItem> currentItems,
    required int targetRecipeId,
    required Set<int> lockedRecipeIds,
    int refreshNonce = 0,
    int replaceNonce = 0,
  }) async {
    if (lockedRecipeIds.contains(targetRecipeId)) {
      return const ReplaceSingleItemResult(
        success: false,
        message: '该菜已锁定，无法替换',
      );
    }

    final targetIndex =
        currentItems.indexWhere((item) => item.recipe.id == targetRecipeId);
    if (targetIndex < 0) {
      return const ReplaceSingleItemResult(
        success: false,
        message: '未找到要替换的菜',
      );
    }

    final targetItem = currentItems[targetIndex];
    final targetType = targetItem.recipe.courseType;

    final recipes = await _recipeService.fetchActiveRecipes();
    final season = _monthToSeason(DateTime.now().month);
    final preferredCuisines = profile.effectivePreferredCuisines;
    final localCuisine = profile.localCuisine;
    final dailySeed = _dailySeed(
      profile.id,
      refreshNonce + replaceNonce + 97,
    );

    final scored = recipes
        .map((recipe) => _scoreRecipe(
              recipe: recipe,
              profile: profile,
              preferredCuisines: preferredCuisines,
              localCuisine: localCuisine,
              season: season,
              tieBreaker: _stableTieBreaker(recipe.id, dailySeed),
            ))
        .toList()
      ..sort((a, b) {
        if (b.score != a.score) return b.score.compareTo(a.score);
        if (a.tieBreaker != b.tieBreaker) {
          return a.tieBreaker.compareTo(b.tieBreaker);
        }
        return a.recipe.id.compareTo(b.recipe.id);
      });

    final currentIds = currentItems.map((item) => item.recipe.id).toSet();
    final candidates = scored.where((item) {
      return item.recipe.courseType == targetType &&
          !currentIds.contains(item.recipe.id);
    }).toList();

    if (candidates.isEmpty) {
      return const ReplaceSingleItemResult(
        success: false,
        message: '没有可替换的候选菜了',
      );
    }

    final replacement = _pickReplacementCandidate(
      candidates: candidates,
      dailySeed: dailySeed,
      replaceNonce: replaceNonce,
    );
    final updatedItems = List<RecommendedMenuItem>.from(currentItems);
    updatedItems[targetIndex] = replacement.toMenuItem();

    final uniqueCount =
        updatedItems.map((item) => item.recipe.id).toSet().length;
    if (uniqueCount != updatedItems.length) {
      return const ReplaceSingleItemResult(
        success: false,
        message: '替换后出现重复菜品，请重试',
      );
    }

    return ReplaceSingleItemResult(
      success: true,
      message: '替换成功',
      updatedItems: updatedItems,
    );
  }

  _ScoredRecipe _scoreRecipe({
    required Recipe recipe,
    required UserProfile profile,
    required List<String> preferredCuisines,
    required String localCuisine,
    required String season,
    required int tieBreaker,
  }) {
    var score = 0;
    final reasons = <String>[];

    var cuisineScore = 0;
    if (preferredCuisines.contains(recipe.cuisine)) {
      cuisineScore += 45;
      reasons.add('命中偏好菜系');
    }
    if (recipe.cuisine == localCuisine) {
      cuisineScore += 25;
      reasons.add('命中本地菜系');
    }
    score += cuisineScore;

    var tasteHits = 0;
    for (final taste in profile.tastePrefs) {
      if (recipe.tasteTags.contains(taste)) {
        tasteHits += 1;
      }
    }
    if (tasteHits > 0) {
      final tasteScore = min(tasteHits, 2) * 12;
      score += tasteScore;
      reasons.add('命中口味${min(tasteHits, 2)}项');
    }

    if (recipe.seasons.contains(season)) {
      score += 18;
      reasons.add('命中当季');
    }

    var geoBonus = 0;
    if (profile.province != null &&
        profile.province!.isNotEmpty &&
        profile.province == recipe.province) {
      geoBonus += 8;
      reasons.add('同省');
    }
    if (profile.city != null &&
        profile.city!.isNotEmpty &&
        profile.city == recipe.city) {
      geoBonus += 12;
      reasons.add('同市');
    }
    score += geoBonus;

    if (reasons.isEmpty) {
      reasons.add('基础匹配');
    }

    return _ScoredRecipe(
      recipe: recipe,
      score: score,
      reasons: reasons,
      tieBreaker: tieBreaker,
    );
  }

  _MenuPattern _parseMenuPattern(String raw) {
    final matched = RegExp(r'^(\d+)菜(\d+)汤$').firstMatch(raw);
    if (matched == null) {
      return const _MenuPattern(dishCount: 2, soupCount: 1);
    }
    return _MenuPattern(
      dishCount: int.parse(matched.group(1)!),
      soupCount: int.parse(matched.group(2)!),
    );
  }

  String _monthToSeason(int month) {
    if (month >= 3 && month <= 5) return 'spring';
    if (month >= 6 && month <= 8) return 'summer';
    if (month >= 9 && month <= 11) return 'autumn';
    return 'winter';
  }

  int _dailySeed(String userId, int refreshNonce) {
    final now = DateTime.now();
    final dayCode = now.year * 10000 + now.month * 100 + now.day;
    return userId.hashCode ^ dayCode ^ (refreshNonce * 7919);
  }

  int _stableTieBreaker(int recipeId, int dailySeed) {
    final mixed = recipeId * 1103515245 + dailySeed * 12345;
    return mixed & 0x7fffffff;
  }

  List<_ScoredRecipe> _pickWithinTopWindow({
    required List<_ScoredRecipe> pool,
    required int count,
    required int dailySeed,
    required int refreshNonce,
    required int salt,
  }) {
    if (count <= 0 || pool.isEmpty) return const <_ScoredRecipe>[];
    if (pool.length <= count || refreshNonce == 0) {
      return pool.take(min(count, pool.length)).toList();
    }

    final windowSize = min(pool.length, max(count * 3, count + 2));
    final maxOffset = windowSize - count;
    if (maxOffset <= 0) {
      return pool.take(min(count, pool.length)).toList();
    }

    final baseOffset = ((dailySeed ^ (salt * 2654435761)) & 0x7fffffff) %
        (maxOffset + 1);
    final offset = (baseOffset + refreshNonce) % (maxOffset + 1);
    return pool.skip(offset).take(count).toList();
  }

  _ScoredRecipe _pickReplacementCandidate({
    required List<_ScoredRecipe> candidates,
    required int dailySeed,
    required int replaceNonce,
  }) {
    if (candidates.length == 1) {
      return candidates.first;
    }
    final windowSize = min(candidates.length, 6);
    final baseOffset =
        ((dailySeed ^ (replaceNonce * 104729)) & 0x7fffffff) % windowSize;
    return candidates[baseOffset];
  }
}

class _ScoredRecipe {
  const _ScoredRecipe({
    required this.recipe,
    required this.score,
    required this.reasons,
    required this.tieBreaker,
  });

  final Recipe recipe;
  final int score;
  final List<String> reasons;
  final int tieBreaker;

  RecommendedMenuItem toMenuItem() {
    return RecommendedMenuItem(
      recipe: recipe,
      score: score,
      reasons: reasons,
    );
  }
}

class _MenuPattern {
  const _MenuPattern({
    required this.dishCount,
    required this.soupCount,
  });

  final int dishCount;
  final int soupCount;
}
