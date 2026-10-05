import 'package:flutter/material.dart';
import 'settings_row.dart';

class SettingsAboutTile extends StatelessWidget {
  final String title;
  final String version;
  final VoidCallback? onTap;

  const SettingsAboutTile({
    super.key,
    required this.title,
    required this.version,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsRow(
      icon: Icons.info_outline_rounded,
      iconColor: Theme.of(context).colorScheme.onSurfaceVariant,
      title: title,
      subtitle: version,
      onTap: onTap,
    );
  }
}
