class Recipe {
  const Recipe({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.region,
    required this.province,
    required this.city,
    required this.seasons,
    required this.tasteTags,
    required this.courseType,
    required this.cookMinutes,
  });

  final int id;
  final String name;
  final String cuisine;
  final String region;
  final String? province;
  final String? city;
  final List<String> seasons;
  final List<String> tasteTags;
  final String courseType;
  final int cookMinutes;

  bool get isSoup => courseType == 'soup';
  bool get isDish => courseType == 'dish';

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: (map['id'] as num).toInt(),
      name: map['name'] as String,
      cuisine: map['cuisine'] as String? ?? '江浙菜',
      region: map['region'] as String,
      province: map['province'] as String?,
      city: map['city'] as String?,
      seasons: (map['seasons'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      tasteTags: (map['taste_tags'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      courseType: map['course_type'] as String,
      cookMinutes: (map['cook_minutes'] as num).toInt(),
    );
  }
}
