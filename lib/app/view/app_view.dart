import 'package:app_ui/app_ui.dart';
import 'package:daikoon/auth/auth.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: const AppTheme().theme,
      darkTheme: const AppDarkTheme().theme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AuthPage(),
    );
  }
}
