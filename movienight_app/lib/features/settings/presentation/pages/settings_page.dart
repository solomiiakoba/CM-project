import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movienight_app/shared/providers/theme_provider.dart';
import 'package:movienight_app/shared/providers/locale_provider.dart';
import 'package:movienight_app/l10n/app_localizations.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;
    
    // Determine if the current theme is actually dark mode (handling system theme fallback)
    final isDarkMode = themeMode == ThemeMode.dark || 
        (themeMode == ThemeMode.system && 
         MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(l10n.darkMode),
            subtitle: Text(l10n.darkModeDescription),
            value: isDarkMode,
            onChanged: (value) {
              ref.read(themeProvider.notifier).toggleTheme(value);
            },
            secondary: Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Text(l10n.languageDescription),
            trailing: DropdownButton<String>(
              value: locale.languageCode,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  ref.read(localeProvider.notifier).setLocale(Locale(newValue));
                }
              },
              items: const [
                DropdownMenuItem(
                  value: 'pt',
                  child: Text('Português'),
                ),
                DropdownMenuItem(
                  value: 'en',
                  child: Text('English'),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.aboutTitle),
            subtitle: Text(l10n.aboutVersion),
          ),
        ],
      ),
    );
  }
}
