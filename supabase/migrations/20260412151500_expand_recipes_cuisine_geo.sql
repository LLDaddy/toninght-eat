alter table public.recipes
  add column if not exists cuisine text not null default '江浙菜',
  add column if not exists province text,
  add column if not exists city text;

update public.recipes
set cuisine = '江浙菜'
where cuisine is null or cuisine = '';
