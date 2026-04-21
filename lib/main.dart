import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'l10n/app_localizations.dart';
import 'l10n/l10n_ext.dart';
import 'models/user_profile.dart';
import 'pages/auth_gate.dart';
import 'pages/main_shell_page.dart';
import 'ui/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const previewMode = bool.fromEnvironment('HOME_UI_PREVIEW');

  if (previewMode) {
    runApp(const TonightEatPreviewApp());
    return;
  }

  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    runApp(const _StartupErrorApp(type: _StartupErrorType.missingEnv));
    return;
  }

  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];
  if (supabaseUrl == null || supabaseAnonKey == null) {
    runApp(const _StartupErrorApp(type: _StartupErrorType.missingSupabaseKeys));
    return;
  }

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  runApp(const TonightEatApp());
}

class TonightEatPreviewApp extends StatelessWidget {
  const TonightEatPreviewApp({super.key});

  static const _previewProfile = UserProfile(
    id: 'preview-user',
    phone: '+8613800138000',
    region: '华东',
    province: '浙江省',
    city: '宁波市',
    preferredCuisines: <String>['江西菜'],
    familySize: 3,
    tastePrefs: <String>['鲜香', '微辣'],
    dislikedIngredients: <String>[],
    menuPattern: '3菜1汤',
    onboardingCompleted: true,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => context.l10n.appTitle,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.themeData,
      home: const MainShellPage(profile: _previewProfile),
    );
  }
}

class TonightEatApp extends StatelessWidget {
  const TonightEatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => context.l10n.appTitle,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.themeData,
      home: const AuthGate(),
    );
  }
}

class _StartupErrorApp extends StatelessWidget {
  const _StartupErrorApp({required this.type});

  final _StartupErrorType type;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => context.l10n.appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(
          child: Text(
            switch (type) {
              _StartupErrorType.missingEnv => context.l10n.startupMissingEnv,
              _StartupErrorType.missingSupabaseKeys =>
                context.l10n.startupMissingSupabaseKeys,
            },
          ),
        ),
      ),
    );
  }
}

enum _StartupErrorType {
  missingEnv,
  missingSupabaseKeys,
}
