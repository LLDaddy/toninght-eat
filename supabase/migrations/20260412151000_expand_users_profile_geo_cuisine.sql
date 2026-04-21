alter table public.users_profile
  add column if not exists province text,
  add column if not exists city text,
  add column if not exists preferred_cuisines text[] not null default '{}';

-- Backfill for legacy users created in Phase 1 with only "region".
update public.users_profile
set preferred_cuisines = case
  when region = '华东' then '{"江浙菜"}'::text[]
  when region = '华中' then '{"江西菜"}'::text[]
  when region = '华南' then '{"粤菜"}'::text[]
  when region = '华北' then '{"鲁菜"}'::text[]
  when region = '西南' then '{"川菜"}'::text[]
  else preferred_cuisines
end
where coalesce(array_length(preferred_cuisines, 1), 0) = 0
  and region is not null;
