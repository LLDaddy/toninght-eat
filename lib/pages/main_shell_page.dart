import 'package:flutter/material.dart';

import '../l10n/l10n_ext.dart';
import '../models/user_profile.dart';
import '../ui/app_tokens.dart';
import '../ui/components/app_scaffold.dart';
import '../ui/components/section_card.dart';
import 'recipes_page.dart';
import 'today_menu_page.dart';

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key, required this.profile});

  final UserProfile profile;

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  final TodayMenuController _todayMenuController = TodayMenuController();
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final isHomeTab = _index == 0;
    return AppScaffold(
      title: _titleByIndex(_index),
      actions: isHomeTab ? null : _buildActions(),
      showAppBar: !isHomeTab,
      showBottomNav: true,
      currentIndex: _index,
      onTabSelected: (value) => setState(() => _index = value),
      body: IndexedStack(
        index: _index,
        children: [
          TodayMenuPage(
            profile: widget.profile,
            embedded: true,
            controller: _todayMenuController,
          ),
          const RecipesPage(),
          _PlaceholderTab(label: context.l10n.mainShellFavoritesTabPlaceholder),
          _PlaceholderTab(label: context.l10n.mainShellMineTabPlaceholder),
        ],
      ),
    );
  }

  List<Widget>? _buildActions() {
    if (_index == 0) return null;
    return [
      IconButton(
        onPressed: () => _todayMenuController.logout(),
        icon: const Icon(Icons.logout),
        tooltip: context.l10n.mainShellLogoutTooltip,
      ),
    ];
  }

  String _titleByIndex(int index) {
    return switch (index) {
      0 => context.l10n.commonHome,
      1 => context.l10n.commonRecipes,
      2 => context.l10n.commonFavorites,
      _ => context.l10n.commonMine,
    };
  }
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: SectionCard(
        child: SizedBox(
          width: double.infinity,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: AppTextSize.lg),
          ),
        ),
      ),
    );
  }
}
