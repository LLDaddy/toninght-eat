# Tonight Eat - Phase 1

## 1) Initialize Flutter platform folders (Android/iOS)

```powershell
cd D:\caipu\tonight_eat
flutter create . --platforms=android,ios
flutter pub get
```

## 2) Configure environment variables

```powershell
copy .env.example .env
```

Edit `.env`:

```env
SUPABASE_URL=https://your-project-ref.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

## 3) Apply database migration

Run SQL file in Supabase SQL editor:

- `supabase/migrations/20260412114000_create_users_profile.sql`
- `supabase/migrations/20260412130000_create_recipes.sql`
- `supabase/migrations/20260412151000_expand_users_profile_geo_cuisine.sql`
- `supabase/migrations/20260412151500_expand_recipes_cuisine_geo.sql`
- `supabase/migrations/20260412173000_dedup_recipes_and_unique_key.sql`
- `supabase/seeds/20260412130500_seed_recipes_jiangzhe_sample.sql`
- `supabase/seeds/20260412152000_seed_recipes_jiangxi_sample.sql`

## 4) Run app

```powershell
flutter run
```

## 5) L10n lint (Phase 5G.5)

Run localization checks:

```powershell
python scripts/l10n_lint.py
```

PowerShell wrapper:

```powershell
.\scripts\l10n_lint.ps1
```

Rules covered:

- Block corruption markers: `????`, `浠`, `鎶`, `鍚`
- Block Chinese characters in `lib/l10n/app_en.arb`
- Validate zh/en placeholder parity per key (for example `{name}`)
- Warn on EN copy length risks (default thresholds):
  - CTA-like keys: `<= 18`
  - Title-like keys: `<= 28`
  - Snackbar-like keys: `<= 72`

Exit code:

- `0`: no lint errors (warnings may exist)
- `1`: one or more lint errors

## 6) pages copy gate (Phase 6Q/6S)

Scan `lib/pages/**/*.dart` for hardcoded CJK UI strings:

```powershell
python scripts/recipes_page_l10n_gate.py
```

Run fixture self-test:

```powershell
python scripts/recipes_page_l10n_gate.py --self-test
```

CI workflow:

- `.github/workflows/recipes-page-l10n-gate.yml`
- `pages-l10n-self-test` runs `python scripts/recipes_page_l10n_gate.py --self-test`
- `pages-l10n-gate` runs `python scripts/recipes_page_l10n_gate.py`
