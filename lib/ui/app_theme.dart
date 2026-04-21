import 'package:flutter/material.dart';

import 'app_tokens.dart';

class AppTheme {
  static const List<String> cjkFontFallback = <String>[
    'PingFang SC',
    'Microsoft YaHei',
    'Noto Sans CJK SC',
    'Noto Sans SC',
    'Heiti SC',
    'WenQuanYi Zen Hei',
    'sans-serif',
  ];

  static TextStyle? _fallbackStyle(TextStyle? style) {
    if (style == null) return null;
    return style.copyWith(fontFamilyFallback: cjkFontFallback);
  }

  static TextTheme _fallbackTextTheme(TextTheme textTheme) {
    return textTheme.copyWith(
      displayLarge: _fallbackStyle(textTheme.displayLarge),
      displayMedium: _fallbackStyle(textTheme.displayMedium),
      displaySmall: _fallbackStyle(textTheme.displaySmall),
      headlineLarge: _fallbackStyle(textTheme.headlineLarge),
      headlineMedium: _fallbackStyle(textTheme.headlineMedium),
      headlineSmall: _fallbackStyle(textTheme.headlineSmall),
      titleLarge: _fallbackStyle(textTheme.titleLarge),
      titleMedium: _fallbackStyle(textTheme.titleMedium),
      titleSmall: _fallbackStyle(textTheme.titleSmall),
      bodyLarge: _fallbackStyle(textTheme.bodyLarge),
      bodyMedium: _fallbackStyle(textTheme.bodyMedium),
      bodySmall: _fallbackStyle(textTheme.bodySmall),
      labelLarge: _fallbackStyle(textTheme.labelLarge),
      labelMedium: _fallbackStyle(textTheme.labelMedium),
      labelSmall: _fallbackStyle(textTheme.labelSmall),
    );
  }

  static ThemeData get themeData {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
    );
    final scheme = const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.brand,
      onPrimary: Color(0xFF2A1707),
      secondary: AppColors.brandBright,
      onSecondary: Color(0xFF2A1707),
      error: Color(0xFFFF7D7D),
      onError: Color(0xFF2A0707),
      surface: AppColors.cardBg,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.cardBgSoft,
      onSurfaceVariant: AppColors.textSecondary,
      outline: AppColors.border,
      outlineVariant: AppColors.borderSoft,
      shadow: Color(0x66000000),
      scrim: Color(0xAA000000),
      inverseSurface: AppColors.textPrimary,
      onInverseSurface: AppColors.pageBgDeep,
      inversePrimary: AppColors.brandBright,
    );

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.pageBg,
      textTheme: _fallbackTextTheme(
        base.textTheme.apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        ),
      ),
      primaryTextTheme: _fallbackTextTheme(
        base.primaryTextTheme.apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.pageBgDeep,
        foregroundColor: AppColors.brandBright,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: AppTextSize.lg,
          fontWeight: FontWeight.w700,
          color: AppColors.brandBright,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderSoft,
        thickness: 1,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: const BorderSide(color: AppColors.border),
        ),
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputFill,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintStyle: const TextStyle(color: AppColors.textMuted),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.borderSoft),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.brand, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: Color(0xFFFF7D7D)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: Color(0xFFFF7D7D), width: 1.4),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.inputFill,
        selectedColor: AppColors.brandSoft,
        secondarySelectedColor: AppColors.brandSoft,
        checkmarkColor: AppColors.brandBright,
        disabledColor: AppColors.disabledBg,
        side: const BorderSide(color: AppColors.borderSoft),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        labelStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: AppTextSize.md,
        ),
        secondaryLabelStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppTextSize.md,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.brand,
          foregroundColor: const Color(0xFF2A1707),
          disabledBackgroundColor: AppColors.disabledBg,
          disabledForegroundColor: AppColors.disabledFg,
          minimumSize: const Size(0, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border),
          minimumSize: const Size(0, 42),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.brandBright,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.pageBgDeep,
        indicatorColor: AppColors.brandSoft,
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(color: AppColors.brandBright);
          }
          return const IconThemeData(color: AppColors.textMuted);
        }),
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(
            fontSize: AppTextSize.sm,
            color: AppColors.textSecondary,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.cardBgSoft,
        contentTextStyle: const TextStyle(color: AppColors.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}
