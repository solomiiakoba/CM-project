import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../shared/providers/locale_provider.dart';
import '../shared/providers/theme_provider.dart';
import 'main_navigation_page.dart';
import 'theme.dart';

/// Root widget of MovieNight app.
/// Configures internationalization, themes and top-level navigation.
class MovieNightApp extends ConsumerWidget {
  const MovieNightApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'MovieNight',
      debugShowCheckedModeBanner: false,
      // Disable animated theme transitions — prevents TextStyle lerp issues
      // when switching between light and dark themes.
      themeAnimationDuration: Duration.zero,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt'),
        Locale('en'),
      ],
      locale: locale,
      theme: MovieNightTheme.light,
      darkTheme: MovieNightTheme.dark,
      themeMode: themeMode,
      home: const MainNavigationPage(),
    );
  }
}
