import 'package:flutter/material.dart';
import 'package:tonight_eat/l10n/app_localizations.dart';

class PassFixturePage extends StatelessWidget {
  const PassFixturePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.commonHome)),
      body: Center(child: Text(l10n.commonRecipes)),
    );
  }
}
