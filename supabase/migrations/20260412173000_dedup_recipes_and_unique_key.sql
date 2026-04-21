-- For environments that seeded data before unique key existed.
delete from public.recipes a
using public.recipes b
where a.id > b.id
  and a.name = b.name
  and a.cuisine = b.cuisine;

create unique index if not exists idx_recipes_name_cuisine_uniq
on public.recipes(name, cuisine);
