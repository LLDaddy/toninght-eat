import '../models/user_profile.dart';
import 'supabase_service.dart';

class ProfileService {
  static const String _table = 'users_profile';

  Future<UserProfile?> getProfile(String userId) async {
    final result = await SupabaseService.client
        .from(_table)
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (result == null) {
      return null;
    }
    return UserProfile.fromMap(result);
  }

  Future<void> upsertOnboarding({
    required String userId,
    required String phone,
    required String region,
    required String province,
    required String city,
    required List<String> preferredCuisines,
    required int familySize,
    required List<String> tastePrefs,
    required List<String> dislikedIngredients,
    required String menuPattern,
  }) async {
    await SupabaseService.client.from(_table).upsert({
      'id': userId,
      'phone': phone,
      'region': region,
      'province': province,
      'city': city,
      'preferred_cuisines': preferredCuisines,
      'family_size': familySize,
      'taste_prefs': tastePrefs,
      'disliked_ingredients': dislikedIngredients,
      'menu_pattern': menuPattern,
      'onboarding_completed': true,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    });
  }
}
