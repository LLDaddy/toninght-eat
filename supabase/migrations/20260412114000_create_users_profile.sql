create table if not exists public.users_profile (
  id uuid primary key references auth.users(id) on delete cascade,
  phone text,
  region text,
  family_size int,
  taste_prefs text[] default '{}',
  disliked_ingredients text[] default '{}',
  menu_pattern text,
  onboarding_completed boolean not null default false,
  updated_at timestamp with time zone default now()
);

alter table public.users_profile enable row level security;

create policy if not exists "Users can read own profile"
on public.users_profile
for select
using (auth.uid() = id);

create policy if not exists "Users can insert own profile"
on public.users_profile
for insert
with check (auth.uid() = id);

create policy if not exists "Users can update own profile"
on public.users_profile
for update
using (auth.uid() = id)
with check (auth.uid() = id);
