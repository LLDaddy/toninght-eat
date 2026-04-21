import 'package:flutter/material.dart';

import '../l10n/l10n_ext.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../ui/app_tokens.dart';
import '../ui/components/primary_button.dart';
import '../ui/components/section_card.dart';
import 'recipe_detail_page.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  static const _previewMode = bool.fromEnvironment('HOME_UI_PREVIEW');

  final RecipeService _recipeService = RecipeService();
  final TextEditingController _searchController = TextEditingController();

  bool _loading = true;
  String? _error;
  List<Recipe> _recipes = <Recipe>[];
  _RecipeTypeFilter _typeFilter = _RecipeTypeFilter.all;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRecipes() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final list = _previewMode
          ? _previewRecipes
          : await _recipeService.fetchActiveRecipes();
      if (!mounted) return;
      setState(() {
        _recipes = List<Recipe>.from(list);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = context.l10n.recipesLoadFailed(e.toString());
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  List<Recipe> _filteredRecipes() {
    final query = _searchController.text.trim().toLowerCase();
    final filtered = _recipes.where((recipe) {
      final typeMatch = switch (_typeFilter) {
        _RecipeTypeFilter.all => true,
        _RecipeTypeFilter.dish => recipe.isDish,
        _RecipeTypeFilter.soup => recipe.isSoup,
      };

      if (!typeMatch) return false;
      if (query.isEmpty) return true;

      return recipe.name.toLowerCase().contains(query) ||
          recipe.cuisine.toLowerCase().contains(query) ||
          recipe.tasteTags.any((tag) => tag.toLowerCase().contains(query));
    }).toList();

    filtered.sort((a, b) => a.id.compareTo(b.id));
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _recipes.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: SectionCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.md),
              PrimaryButton(
                label: context.l10n.commonRetry,
                onPressed: _loadRecipes,
              ),
            ],
          ),
        ),
      );
    }

    final list = _filteredRecipes();
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          SectionCard(
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: context.l10n.recipesSearchLabel,
                    hintText: context.l10n.recipesSearchHint,
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    _FilterChipButton(
                      label: context.l10n.recipesFilterAll,
                      selected: _typeFilter == _RecipeTypeFilter.all,
                      onTap: () =>
                          setState(() => _typeFilter = _RecipeTypeFilter.all),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _FilterChipButton(
                      label: context.l10n.commonDish,
                      selected: _typeFilter == _RecipeTypeFilter.dish,
                      onTap: () =>
                          setState(() => _typeFilter = _RecipeTypeFilter.dish),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _FilterChipButton(
                      label: context.l10n.commonSoup,
                      selected: _typeFilter == _RecipeTypeFilter.soup,
                      onTap: () =>
                          setState(() => _typeFilter = _RecipeTypeFilter.soup),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    context.l10n.recipesCount(list.length),
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: list.isEmpty
                ? SectionCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          context.l10n.recipesEmpty,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        PrimaryButton(
                          label: context.l10n.recipesClearFilters,
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _typeFilter = _RecipeTypeFilter.all;
                            });
                          },
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final recipe = list[index];
                      return SectionCard(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      RecipeDetailPage(recipe: recipe),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.xs),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          recipe.name,
                                          style: const TextStyle(
                                            fontSize: AppTextSize.lg,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      _TypeTag(type: recipe.courseType),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    context.l10n.todayCuisineAndMinutes(
                                      recipe.cuisine,
                                      recipe.cookMinutes,
                                    ),
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  if (recipe.tasteTags.isNotEmpty) ...[
                                    const SizedBox(height: AppSpacing.sm),
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 6,
                                      children: recipe.tasteTags
                                          .map(
                                            (tag) => Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.inputFill,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: AppColors.borderSoft,
                                                ),
                                              ),
                                              child: Text(
                                                tag,
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

enum _RecipeTypeFilter { all, dish, soup }

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.brand.withValues(alpha: 0.26)
              : AppColors.inputFill,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.brandBright : AppColors.borderSoft,
          ),
        ),
        child: Text(label),
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

const List<Recipe> _previewRecipes = [
  Recipe(
    id: 8001,
    name: '葱油拌面',
    cuisine: '江浙菜',
    region: '华东',
    province: '浙江省',
    city: '宁波市',
    seasons: <String>['spring', 'summer', 'autumn', 'winter'],
    tasteTags: <String>['鲜香'],
    courseType: 'dish',
    cookMinutes: 15,
  ),
  Recipe(
    id: 8002,
    name: '清炒时蔬',
    cuisine: '江浙菜',
    region: '华东',
    province: '浙江省',
    city: '杭州市',
    seasons: <String>['spring', 'summer'],
    tasteTags: <String>['清淡'],
    courseType: 'dish',
    cookMinutes: 10,
  ),
  Recipe(
    id: 8003,
    name: '莲藕排骨汤',
    cuisine: '江西菜',
    region: '华中',
    province: '江西省',
    city: '南昌市',
    seasons: <String>['autumn', 'winter'],
    tasteTags: <String>['鲜香'],
    courseType: 'soup',
    cookMinutes: 50,
  ),
  Recipe(
    id: 8004,
    name: '小炒黄牛肉',
    cuisine: '江西菜',
    region: '华中',
    province: '江西省',
    city: '赣州市',
    seasons: <String>['spring', 'summer', 'autumn', 'winter'],
    tasteTags: <String>['香辣'],
    courseType: 'dish',
    cookMinutes: 25,
  ),
];
