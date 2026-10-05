import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../widgets/settings_about_tile.dart';
import '../widgets/settings_card.dart';
import '../widgets/settings_footer.dart';
import '../widgets/settings_language_tile.dart';
import '../widgets/settings_page_header.dart';
import '../widgets/settings_section_label.dart';
import '../widgets/settings_theme_tile.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;

    final isDarkMode = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SettingsPageHeader(
              title: l10n.settings,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SettingsSectionLabel(label: 'Aparência'),
                const SizedBox(height: 10),
                SettingsCard(
                  children: [
                    SettingsThemeTile(
                      isDarkMode: isDarkMode,
                      onChanged: (value) =>
                          ref.read(themeProvider.notifier).toggleTheme(value),
                      title: l10n.darkMode,
                      subtitle: l10n.darkModeDescription,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SettingsSectionLabel(label: l10n.language),
                const SizedBox(height: 10),
                SettingsCard(
                  children: [
                    SettingsLanguageTile(
                      currentLanguageCode: locale.languageCode,
                      onLanguageChanged: (code) {
                        if (code != null) {
                          ref.read(localeProvider.notifier).setLocale(Locale(code));
                        }
                      },
                      title: l10n.language,
                      subtitle: l10n.languageDescription,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SettingsSectionLabel(label: l10n.aboutTitle),
                const SizedBox(height: 10),
                SettingsCard(
                  children: [
                    SettingsAboutTile(
                      title: l10n.aboutTitle,
                      version: l10n.aboutVersion,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const SettingsFooter(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
