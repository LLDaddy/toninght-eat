import 'package:flutter/material.dart';

class AppColors {
  static const Color brand = Color(0xFFF3A530);
  static const Color brandBright = Color(0xFFFFD27A);
  static const Color brandSoft = Color(0xFF4A321A);
  static const Color pageBg = Color(0xFF140E0A);
  static const Color pageBgDeep = Color(0xFF0C0806);
  static const Color cardBg = Color(0xFF24180F);
  static const Color cardBgSoft = Color(0xFF2E1F14);
  static const Color textPrimary = Color(0xFFF8E9D2);
  static const Color textSecondary = Color(0xFFD3BF9E);
  static const Color textMuted = Color(0xFFA88D69);
  static const Color border = Color(0xFF7A542A);
  static const Color borderSoft = Color(0xFF5A3E22);
  static const Color inputFill = Color(0xFF1E140D);
  static const Color disabledBg = Color(0xFF3A2A1B);
  static const Color disabledFg = Color(0xFF8C7658);
  static const Color glow = Color(0x66F3A530);
}

class AppGradients {
  static const LinearGradient appBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      Color(0xFF1B120D),
      AppColors.pageBg,
      AppColors.pageBgDeep,
    ],
  );

  static const LinearGradient ambientGlow = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      Color(0x33F3A530),
      Color(0x11D97A2B),
      Color(0x00000000),
    ],
  );

  static const LinearGradient primaryButton = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[
      Color(0xFFF3A530),
      Color(0xFFDF7E1A),
    ],
  );
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
}

class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
}

class AppTextSize {
  static const double sm = 12;
  static const double md = 14;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
}

class AppShadows {
  static const List<BoxShadow> card = <BoxShadow>[
    BoxShadow(
      color: Color(0x3A000000),
      blurRadius: 14,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x22F3A530),
      blurRadius: 12,
      spreadRadius: -4,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> buttonGlow = <BoxShadow>[
    BoxShadow(
      color: Color(0x66F3A530),
      blurRadius: 16,
      spreadRadius: -2,
      offset: Offset(0, 6),
    ),
  ];
}
