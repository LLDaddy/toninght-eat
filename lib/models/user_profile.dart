import '../config/geo_cuisine_mapping.dart';

class UserProfile {
  const UserProfile({
    required this.id,
    required this.phone,
    required this.region,
    required this.province,
    required this.city,
    required this.preferredCuisines,
    required this.familySize,
    required this.tastePrefs,
    required this.dislikedIngredients,
    required this.menuPattern,
    required this.onboardingCompleted,
  });

  final String id;
  final String? phone;
  final String? region;
  final String? province;
  final String? city;
  final List<String> preferredCuisines;
  final int? familySize;
  final List<String> tastePrefs;
  final List<String> dislikedIngredients;
  final String? menuPattern;
  final bool onboardingCompleted;

  String get localCuisine => resolveLocalCuisine(
        province: province,
        city: city,
        legacyRegion: region,
      );

  List<String> get effectivePreferredCuisines {
    if (preferredCuisines.isNotEmpty) return preferredCuisines;
    return fallbackCuisinesFromLegacyRegion(region);
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    final preferred = (map['preferred_cuisines'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();
    return UserProfile(
      id: map['id'] as String,
      phone: map['phone'] as String?,
      region: map['region'] as String?,
      province: map['province'] as String?,
      city: map['city'] as String?,
      preferredCuisines: preferred,
      familySize: (map['family_size'] as num?)?.toInt(),
      tastePrefs: (map['taste_prefs'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      dislikedIngredients: (map['disliked_ingredients'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      menuPattern: map['menu_pattern'] as String?,
      onboardingCompleted: map['onboarding_completed'] as bool? ?? false,
    );
  }
}
