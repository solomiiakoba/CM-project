import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import 'settings_row.dart';

class SettingsThemeTile extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onChanged;
  final String title;
  final String subtitle;

  const SettingsThemeTile({
    super.key,
    required this.isDarkMode,
    required this.onChanged,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsRow(
      icon: isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
      iconColor: isDarkMode ? MNColors.primaryLight : const Color(0xFFFBBF24),
      title: title,
      subtitle: subtitle,
      trailing: Switch(
        value: isDarkMode,
        onChanged: onChanged,
        activeThumbColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
