-- Phase 2.2 seed (base): 20 Jiangzhe dishes/soups, all cuisine marked as 江浙菜.
-- Target is 100 recipes in later expansion.

insert into public.recipes (
  name, cuisine, region, province, city, seasons, taste_tags, course_type, cook_minutes
)
values
  ('红烧肉', '江浙菜', '江浙', '浙江', '杭州', '{"autumn","winter"}', '{"咸鲜","重口"}', 'dish', 55),
  ('清蒸鲈鱼', '江浙菜', '江浙', '浙江', '温州', '{"spring","summer","autumn"}', '{"清淡","咸鲜"}', 'dish', 25),
  ('龙井虾仁', '江浙菜', '江浙', '浙江', '杭州', '{"spring","summer"}', '{"清淡","咸鲜"}', 'dish', 20),
  ('东坡肉', '江浙菜', '江浙', '浙江', '杭州', '{"autumn","winter"}', '{"重口","咸鲜"}', 'dish', 90),
  ('糖醋里脊', '江浙菜', '江浙', '江苏', '苏州', '{"spring","summer","autumn"}', '{"酸甜"}', 'dish', 35),
  ('油爆虾', '江浙菜', '江浙', '浙江', '绍兴', '{"summer","autumn"}', '{"重口","咸鲜"}', 'dish', 22),
  ('白切鸡', '江浙菜', '江浙', '江苏', '南京', '{"spring","summer"}', '{"清淡"}', 'dish', 40),
  ('杭椒牛柳', '江浙菜', '江浙', '浙江', '杭州', '{"summer","autumn"}', '{"辣","咸鲜"}', 'dish', 25),
  ('梅干菜烧肉', '江浙菜', '江浙', '浙江', '绍兴', '{"autumn","winter"}', '{"重口","咸鲜"}', 'dish', 60),
  ('葱油拌面', '江浙菜', '江浙', '上海', '上海', '{"spring","summer","autumn","winter"}', '{"咸鲜"}', 'dish', 15),
  ('荷塘小炒', '江浙菜', '江浙', '江苏', '无锡', '{"summer"}', '{"清淡"}', 'dish', 18),
  ('腌笃鲜', '江浙菜', '江浙', '上海', '上海', '{"spring"}', '{"清淡","咸鲜"}', 'soup', 70),
  ('西湖牛肉羹', '江浙菜', '江浙', '浙江', '杭州', '{"spring","autumn","winter"}', '{"清淡","咸鲜"}', 'soup', 30),
  ('番茄蛋花汤', '江浙菜', '江浙', '江苏', '南京', '{"spring","summer","autumn","winter"}', '{"酸甜","清淡"}', 'soup', 12),
  ('冬瓜排骨汤', '江浙菜', '江浙', '浙江', '温州', '{"summer","autumn"}', '{"清淡","咸鲜"}', 'soup', 50),
  ('紫菜虾皮汤', '江浙菜', '江浙', '上海', '上海', '{"spring","summer","autumn","winter"}', '{"清淡"}', 'soup', 10),
  ('丝瓜蛤蜊汤', '江浙菜', '江浙', '浙江', '嘉兴', '{"summer"}', '{"清淡","咸鲜"}', 'soup', 15),
  ('萝卜牛腩汤', '江浙菜', '江浙', '江苏', '苏州', '{"autumn","winter"}', '{"咸鲜","重口"}', 'soup', 80),
  ('菌菇豆腐汤', '江浙菜', '江浙', '浙江', '绍兴', '{"spring","autumn","winter"}', '{"清淡"}', 'soup', 18),
  ('鲫鱼豆腐汤', '江浙菜', '江浙', '江苏', '无锡', '{"spring","autumn","winter"}', '{"清淡","咸鲜"}', 'soup', 35)
on conflict (name, cuisine) do nothing;
