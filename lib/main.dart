import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app.dart';

void main() => runApp(const PortfolioRoot());

class PortfolioRoot extends StatefulWidget {
  const PortfolioRoot({super.key});

  @override
  State<PortfolioRoot> createState() => _PortfolioRootState();
}

class _PortfolioRootState extends State<PortfolioRoot> {
  Locale _locale = const Locale('ru');
  ThemeMode _themeMode = ThemeMode.light;

  void _changeLocale(Locale locale) {
    if (_locale.languageCode == locale.languageCode) {
      return;
    }
    setState(() {
      _locale = locale;
    });
  }

  void _changeThemeMode(ThemeMode mode) {
    if (_themeMode == mode) {
      return;
    }
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [Locale('ru'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: _themeMode,
      home: PortfolioApp(
        locale: _locale,
        onLocaleChanged: _changeLocale,
        themeMode: _themeMode,
        onThemeModeChanged: _changeThemeMode,
      ),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0E7490),
        brightness: brightness,
      ),
      scaffoldBackgroundColor: brightness == Brightness.light
          ? const Color(0xFFF7FAFC)
          : const Color(0xFF0B1120),
    );
  }
}
