-- Phase 2.2 extra seed: 江西菜 sample set for weighted preference testing.

insert into public.recipes (
  name, cuisine, region, province, city, seasons, taste_tags, course_type, cook_minutes
)
values
  ('藜蒿炒腊肉', '江西菜', '江西', '江西', '南昌', '{"spring","summer"}', '{"重口","咸鲜"}', 'dish', 25),
  ('井冈山烟笋炒肉', '江西菜', '江西', '江西', '赣州', '{"spring","autumn"}', '{"辣","咸鲜"}', 'dish', 30),
  ('三杯鸡', '江西菜', '江西', '江西', '南昌', '{"spring","summer","autumn","winter"}', '{"重口","咸鲜"}', 'dish', 40),
  ('米粉蒸肉', '江西菜', '江西', '江西', '九江', '{"autumn","winter"}', '{"重口","咸鲜"}', 'dish', 55),
  ('南昌拌粉', '江西菜', '江西', '江西', '南昌', '{"spring","summer","autumn","winter"}', '{"辣","咸鲜"}', 'dish', 15),
  ('赣南小炒鱼', '江西菜', '江西', '江西', '赣州', '{"spring","summer","autumn"}', '{"辣","重口"}', 'dish', 20),
  ('瓦罐莲藕排骨汤', '江西菜', '江西', '江西', '南昌', '{"autumn","winter"}', '{"咸鲜","清淡"}', 'soup', 70),
  ('瓦罐冬瓜老鸭汤', '江西菜', '江西', '江西', '九江', '{"summer","autumn"}', '{"清淡","咸鲜"}', 'soup', 65),
  ('瓦罐萝卜牛腩汤', '江西菜', '江西', '江西', '赣州', '{"autumn","winter"}', '{"咸鲜","重口"}', 'soup', 80)
on conflict (name, cuisine) do nothing;
