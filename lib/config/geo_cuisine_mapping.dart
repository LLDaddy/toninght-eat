const List<String> supportedCuisines = <String>[
  '江浙菜',
  '江西菜',
  '川菜',
  '湘菜',
  '粤菜',
  '闽菜',
  '鲁菜',
  '徽菜',
];

const Map<String, List<String>> provinceCityOptions = <String, List<String>>{
  '上海': <String>['上海'],
  '江苏': <String>['南京', '苏州', '无锡', '常州', '南通'],
  '浙江': <String>['杭州', '宁波', '温州', '绍兴', '嘉兴'],
  '安徽': <String>['合肥', '芜湖', '安庆'],
  '福建': <String>['福州', '厦门', '泉州'],
  '山东': <String>['济南', '青岛', '烟台'],
  '江西': <String>['南昌', '赣州', '九江'],
};

const Map<String, String> _provinceCuisineMap = <String, String>{
  '上海': '江浙菜',
  '江苏': '江浙菜',
  '浙江': '江浙菜',
  '安徽': '徽菜',
  '福建': '闽菜',
  '山东': '鲁菜',
  '江西': '江西菜',
};

const Map<String, String> _cityCuisineOverrides = <String, String>{
  '宁波': '江浙菜',
  '杭州': '江浙菜',
  '南昌': '江西菜',
  '赣州': '江西菜',
};

const Map<String, String> _provinceRegionMap = <String, String>{
  '上海': '华东',
  '江苏': '华东',
  '浙江': '华东',
  '安徽': '华东',
  '福建': '华东',
  '山东': '华东',
  '江西': '华中',
};

const Map<String, List<String>> _legacyRegionCuisineMap = <String, List<String>>{
  '华东': <String>['江浙菜'],
  '华中': <String>['江西菜'],
  '华南': <String>['粤菜'],
  '华北': <String>['鲁菜'],
  '西南': <String>['川菜'],
};

String inferRegionFromProvince(String? province) {
  if (province == null || province.isEmpty) return '华东';
  return _provinceRegionMap[province] ?? '华东';
}

String resolveLocalCuisine({
  required String? province,
  required String? city,
  required String? legacyRegion,
}) {
  if (city != null && city.isNotEmpty && _cityCuisineOverrides.containsKey(city)) {
    return _cityCuisineOverrides[city]!;
  }
  if (province != null &&
      province.isNotEmpty &&
      _provinceCuisineMap.containsKey(province)) {
    return _provinceCuisineMap[province]!;
  }
  final legacy = fallbackCuisinesFromLegacyRegion(legacyRegion);
  if (legacy.isNotEmpty) return legacy.first;
  return '江浙菜';
}

List<String> fallbackCuisinesFromLegacyRegion(String? region) {
  if (region == null || region.isEmpty) return const <String>[];
  return List<String>.from(_legacyRegionCuisineMap[region] ?? const <String>[]);
}
