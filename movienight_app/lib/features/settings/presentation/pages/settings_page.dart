import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movienight_app/app/theme.dart';
import 'package:movienight_app/shared/providers/theme_provider.dart';
import 'package:movienight_app/shared/providers/locale_provider.dart';
import 'package:movienight_app/l10n/app_localizations.dart';
import 'package:movienight_app/shared/widgets/particle_background.dart';

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

    return Scaffold(
      backgroundColor: MNColors.background,
      body: ParticleBackground(
        particleCount: 20,
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // ── Header ──────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (b) => const LinearGradient(
                          colors: [MNColors.primaryLight, MNColors.secondary],
                        ).createShader(b),
                        child: Text(
                          l10n.settings,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'MovieNight',
                        style: TextStyle(
                          color: MNColors.onSurfaceVar,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // ── Lista de opções ──────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── Secção: Aparência ──────────────────────────────────
                    _SectionLabel(label: 'Aparência'),
                    const SizedBox(height: 10),

                    _SettingsCard(
                      children: [
                        _SettingsRow(
                          icon: isDarkMode
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          iconColor: isDarkMode
                              ? MNColors.primaryLight
                              : const Color(0xFFFBBF24),
                          title: l10n.darkMode,
                          subtitle: l10n.darkModeDescription,
                          trailing: Switch(
                            value: isDarkMode,
                            onChanged: (v) =>
                                ref.read(themeProvider.notifier).toggleTheme(v),
                            activeColor: MNColors.primary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ── Secção: Idioma ─────────────────────────────────────
                    _SectionLabel(label: l10n.language),
                    const SizedBox(height: 10),

                    _SettingsCard(
                      children: [
                        _SettingsRow(
                          icon: Icons.language_rounded,
                          iconColor: MNColors.secondary,
                          title: l10n.language,
                          subtitle: l10n.languageDescription,
                          trailing: _LanguagePicker(
                            value: locale.languageCode,
                            onChanged: (code) => ref
                                .read(localeProvider.notifier)
                                .setLocale(Locale(code!)),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ── Secção: Acerca ─────────────────────────────────────
                    _SectionLabel(label: l10n.aboutTitle),
                    const SizedBox(height: 10),

                    _SettingsCard(
                      children: [
                        _SettingsRow(
                          icon: Icons.info_outline_rounded,
                          iconColor: MNColors.onSurfaceVar,
                          title: l10n.aboutTitle,
                          subtitle: l10n.aboutVersion,
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // ── Rodapé ─────────────────────────────────────────────
                    Center(
                      child: Column(
                        children: [
                          ShaderMask(
                            shaderCallback: (b) => const LinearGradient(
                              colors: [
                                MNColors.primary,
                                MNColors.secondary
                              ],
                            ).createShader(b),
                            child: const Text(
                              'MovieNight 🎬',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Made with ❤️  in Flutter',
                            style: TextStyle(
                              color: MNColors.onSurfaceVar,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Widgets auxiliares
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: MNColors.onSurfaceVar,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MNColors.surfaceVar,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MNColors.outlineVar),
      ),
      child: Column(
        children: List.generate(children.length * 2 - 1, (i) {
          if (i.isOdd) {
            return const Divider(
                height: 1, color: MNColors.outlineVar, indent: 58);
          }
          return children[i ~/ 2];
        }),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const _SettingsRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: MNColors.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: MNColors.onSurfaceVar,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _LanguagePicker extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const _LanguagePicker({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        dropdownColor: MNColors.surfaceVar,
        style: const TextStyle(
          color: MNColors.primaryLight,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        icon: const Icon(Icons.keyboard_arrow_down_rounded,
            color: MNColors.primaryLight, size: 18),
        onChanged: onChanged,
        items: const [
          DropdownMenuItem(value: 'pt', child: Text('🇵🇹  PT')),
          DropdownMenuItem(value: 'en', child: Text('🇬🇧  EN')),
        ],
      ),
    );
  }
}
