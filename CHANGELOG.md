# Changelog

## 0.1.1-rc.1 (2026-04-26)

### Scope
- Completed RC unblock for Android release pipeline on Windows.
- Unified Android SDK/JDK environment and release signing configuration.
- Built signed Android artifacts (`APK` and `AAB`) and generated checksums.
- Kept existing product features unchanged.

### Included Feature Baseline
- OTP login + onboarding flow.
- Today menu draw / lock / replace.
- Recipe detail + local/cloud favorites sync.
- Recipes list filtering / paging / observability export flow.

### Known Issues
- `flutter doctor -v` still reports:
  - Flutter binary path warning (can be fixed by adding Flutter bin to `PATH`).
  - `Network resources` timeout check for `https://maven.google.com/` in current network.
  - Visual Studio missing (not required for Android/Web release).
- `flutter analyze lib --no-fatal-infos` has 6 existing info-level deprecation warnings.
