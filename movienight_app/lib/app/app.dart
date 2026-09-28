import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:movienight_app/l10n/app_localizations.dart';

import '../features/session/presentation/pages/create_session_page.dart';
import '../features/session/presentation/pages/scan_session_page.dart';
import '../core/bluetooth/bluetooth_peripheral_test_page.dart';

import 'theme.dart';
import 'main_navigation_page.dart';
import '../shared/providers/theme_provider.dart';
import '../shared/providers/locale_provider.dart';

class MovieNightApp extends ConsumerWidget {
  const MovieNightApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'MovieNight',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.appTitle,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(l10n.appDescription),

            const SizedBox(height: 32),

            // =================================================
            // CRIAR SESSÃO
            // =================================================

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const CreateSessionPage(),
                  ),
                );
              },
              child: Text(l10n.newSession),
            ),

            const SizedBox(height: 16),

            // =================================================
            // ENTRAR NUMA SESSÃO
            // =================================================

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ScanSessionPage(),
                  ),
                );
              },
              child: Text(l10n.joinSession),
            ),

            const SizedBox(height: 16),

            // =================================================
            // TESTE PERIPHERAL
            // =================================================

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const BluetoothPeripheralTestPage(),
                  ),
                );
              },
              child: Text(l10n.bluetoothPeripheral),
            ),
          ],
        ),
      ),
    );
  }
}
