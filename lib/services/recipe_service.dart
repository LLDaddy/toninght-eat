import '../models/recipe.dart';
import 'supabase_service.dart';

class RecipeService {
  static const _table = 'recipes';

  Future<List<Recipe>> fetchActiveRecipes() async {
    final result = await SupabaseService.client
        .from(_table)
        .select(
          'id,name,cuisine,region,province,city,seasons,taste_tags,course_type,cook_minutes',
        )
        .eq('is_active', true);

    return result.map<Recipe>((row) => Recipe.fromMap(row)).toList();
  }
}
