import '../models/recipe.dart';
import '../models/recipe_detail.dart';

class RecipeDetailService {
  RecipeDetail getDetail(Recipe recipe) {
    final detail = _detailsByRecipeId[recipe.id];
    if (detail != null) return detail;

    final byName = _detailsByRecipeName[recipe.name];
    if (byName != null) return byName;

    return const RecipeDetail(
      ingredients: <String>['主食材（待补充）', '调味料（待补充）'],
      steps: <String>['暂无详细做法'],
    );
  }
}

const Map<int, RecipeDetail> _detailsByRecipeId = <int, RecipeDetail>{
  1: RecipeDetail(
    ingredients: <String>['五花肉 500g', '冰糖 20g', '生抽 2勺', '料酒 1勺', '姜片 4片'],
    steps: <String>[
      '五花肉切块后焯水，捞出备用。',
      '少油下冰糖，小火炒到焦糖色。',
      '下肉块翻炒上色，加入生抽、料酒和姜片。',
      '加热水没过肉，小火炖45分钟后收汁。',
    ],
  ),
  2: RecipeDetail(
    ingredients: <String>['鲈鱼 1条', '姜丝 适量', '葱丝 适量', '蒸鱼豉油 2勺'],
    steps: <String>[
      '鲈鱼处理干净，两面划刀。',
      '放姜丝后上锅蒸8-10分钟。',
      '倒掉盘中水分，放葱丝。',
      '淋蒸鱼豉油，浇热油即可。',
    ],
  ),
  21: RecipeDetail(
    ingredients: <String>['藜蒿 250g', '腊肉 120g', '蒜片 适量', '干辣椒 2个'],
    steps: <String>[
      '腊肉切片后先煸香出油。',
      '加入蒜片和干辣椒爆香。',
      '下藜蒿大火快炒2-3分钟。',
      '少量盐调味后出锅。',
    ],
  ),
};

const Map<String, RecipeDetail> _detailsByRecipeName = <String, RecipeDetail>{
  '西湖牛肉羹': RecipeDetail(
    ingredients: <String>['牛肉末 150g', '香菇末 50g', '鸡蛋 1个', '淀粉 适量'],
    steps: <String>[
      '牛肉末加少量盐和料酒腌制10分钟。',
      '锅中加水，放香菇末煮开。',
      '下牛肉末煮熟后勾薄芡。',
      '淋蛋液搅匀，调味后撒香菜末。',
    ],
  ),
};
