import 'recipe.dart';

class MenuGenerationResult {
  const MenuGenerationResult({
    required this.selectedItems,
    required this.strategy,
    required this.season,
    required this.dishTarget,
    required this.soupTarget,
    required this.localCuisine,
    required this.preferredCuisines,
    required this.relaxed,
  });

  final List<RecommendedMenuItem> selectedItems;
  final String strategy;
  final String season;
  final int dishTarget;
  final int soupTarget;
  final String localCuisine;
  final List<String> preferredCuisines;
  final bool relaxed;

  MenuGenerationResult copyWith({
    List<RecommendedMenuItem>? selectedItems,
    String? strategy,
    String? season,
    int? dishTarget,
    int? soupTarget,
    String? localCuisine,
    List<String>? preferredCuisines,
    bool? relaxed,
  }) {
    return MenuGenerationResult(
      selectedItems: selectedItems ?? this.selectedItems,
      strategy: strategy ?? this.strategy,
      season: season ?? this.season,
      dishTarget: dishTarget ?? this.dishTarget,
      soupTarget: soupTarget ?? this.soupTarget,
      localCuisine: localCuisine ?? this.localCuisine,
      preferredCuisines: preferredCuisines ?? this.preferredCuisines,
      relaxed: relaxed ?? this.relaxed,
    );
  }
}

class RecommendedMenuItem {
  const RecommendedMenuItem({
    required this.recipe,
    required this.score,
    required this.reasons,
  });

  final Recipe recipe;
  final int score;
  final List<String> reasons;
}

class ReplaceSingleItemResult {
  const ReplaceSingleItemResult({
    required this.success,
    required this.message,
    this.updatedItems,
  });

  final bool success;
  final String message;
  final List<RecommendedMenuItem>? updatedItems;
}
