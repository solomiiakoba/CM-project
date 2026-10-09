import 'package:flutter/material.dart';

import '../../../../app/theme.dart';

/// Cabeçalho da página de definições com título em gradiente e subtítulo contextual.
class SettingsPageHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const SettingsPageHeader({
    super.key,
    required this.title,
    this.subtitle = 'Preferências da aplicação',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: isDark
                  ? const [MNColors.primaryLight, MNColors.secondary]
                  : const [Color(0xFF6D28D9), Color(0xFF0284C7)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
                inherit: false,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              color: cs.onSurfaceVariant,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              inherit: false,
            ),
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }
}
