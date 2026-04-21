import 'package:flutter/material.dart';

import '../../l10n/l10n_ext.dart';
import '../app_tokens.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.showBottomNav = false,
    this.currentIndex = 0,
    this.onTabSelected,
    this.showBackgroundGlow = true,
    this.showAppBar = true,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final bool showBottomNav;
  final int currentIndex;
  final ValueChanged<int>? onTabSelected;
  final bool showBackgroundGlow;
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: Text(title),
              actions: actions,
            )
          : null,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: AppGradients.appBackground,
              ),
            ),
          ),
          if (showBackgroundGlow)
            const Positioned(
              top: -40,
              left: -30,
              right: -30,
              height: 220,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: AppGradients.ambientGlow,
                  ),
                ),
              ),
            ),
          SafeArea(top: false, child: body),
        ],
      ),
      bottomNavigationBar: showBottomNav
          ? _ThemedBottomNav(
              currentIndex: currentIndex,
              onSelected: onTabSelected,
            )
          : null,
    );
  }
}

class _ThemedBottomNav extends StatelessWidget {
  const _ThemedBottomNav({
    required this.currentIndex,
    required this.onSelected,
  });

  final int currentIndex;
  final ValueChanged<int>? onSelected;

  @override
  Widget build(BuildContext context) {
    final items = <({IconData icon, String label})>[
      (icon: Icons.home, label: context.l10n.commonHome),
      (icon: Icons.menu_book, label: context.l10n.commonRecipes),
      (icon: Icons.favorite, label: context.l10n.commonFavorites),
      (icon: Icons.person, label: context.l10n.commonMine),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.pageBgDeep,
        border: const Border(
          top: BorderSide(color: AppColors.borderSoft),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x5C000000),
            blurRadius: 14,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 78,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Color(0xFF29180E),
                        AppColors.pageBgDeep,
                      ],
                    ),
                    border: Border(
                      top: BorderSide(
                        color: AppColors.border.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    _NavDivider(),
                    _NavDivider(),
                    _NavCenterDiamond(),
                    _NavDivider(),
                    _NavDivider(),
                  ],
                ),
              ),
              Row(
                children: List.generate(items.length, (index) {
                  final selected = index == currentIndex;
                  return Expanded(
                    child: InkWell(
                      onTap: () => onSelected?.call(index),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              items[index].icon,
                              size: 23,
                              color: selected
                                  ? const Color(0xFFFFDF9A)
                                  : const Color(0xFF907753),
                              shadows: selected
                                  ? const [
                                      Shadow(
                                        color: Color(0x88000000),
                                        blurRadius: 6,
                                        offset: Offset(0, 1),
                                      ),
                                    ]
                                  : const [
                                      Shadow(
                                        color: Color(0x66000000),
                                        blurRadius: 4,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              items[index].label,
                              style: TextStyle(
                                fontSize: AppTextSize.md,
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: selected
                                    ? const Color(0xFFFFDF9A)
                                    : const Color(0xFF9A7F58),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavDivider extends StatelessWidget {
  const _NavDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 1.4,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.brandBright.withValues(alpha: 0.0),
            AppColors.brandBright.withValues(alpha: 0.74),
            AppColors.brandBright.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }
}

class _NavCenterDiamond extends StatelessWidget {
  const _NavCenterDiamond();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.78,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color(0xFFF4C56D),
              Color(0xFFBD7725),
            ],
          ),
          border: Border.all(color: AppColors.brandBright, width: 1.2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x66F3A530),
              blurRadius: 8,
              spreadRadius: -1,
              offset: Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }
}
