import 'package:flutter/material.dart';

import '../l10n/l10n_ext.dart';
import '../models/recipe.dart';
import '../services/recipe_detail_service.dart';
import '../ui/app_tokens.dart';
import '../ui/components/app_scaffold.dart';
import '../ui/components/primary_button.dart';
import '../ui/components/section_card.dart';

class RecipeDetailPage extends StatelessWidget {
  const RecipeDetailPage({
    super.key,
    required this.recipe,
  });

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final detail = RecipeDetailService().getDetail(recipe);
    final typeLabel = recipe.isSoup ? l10n.commonSoup : l10n.commonDish;

    return AppScaffold(
      title: l10n.recipeDetailTitle,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.name,
                        style: const TextStyle(
                          fontSize: AppTextSize.xxl,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        l10n.recipeDetailSummary(
                          typeLabel,
                          recipe.cuisine,
                          recipe.cookMinutes,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.recipeDetailIngredientsTitle,
                        style: TextStyle(
                          fontSize: AppTextSize.lg,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      ...detail.ingredients.map(
                        (ingredient) => Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.xs),
                          child: Text(
                              l10n.recipeDetailIngredientBullet(ingredient)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.recipeDetailStepsTitle,
                        style: TextStyle(
                          fontSize: AppTextSize.lg,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      ...detail.steps.asMap().entries.map(
                            (entry) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.sm),
                              child: Text('${entry.key + 1}. ${entry.value}'),
                            ),
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: AppColors.pageBgDeep,
              border: Border(
                top: BorderSide(color: AppColors.borderSoft),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text(l10n.recipeDetailFavoritePlaceholder)),
                      );
                    },
                    icon: const Icon(Icons.favorite_border),
                    label: Text(l10n.recipeDetailFavoriteButton),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: PrimaryButton(
                    label: l10n.recipeDetailAddTodayMenuButton,
                    icon: const Icon(Icons.playlist_add),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text(l10n.recipeDetailAddTodayMenuPlaceholder),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
