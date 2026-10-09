import 'package:flutter/material.dart';

import '../../../../app/theme.dart';

/// Rodapé da página de definições com copyright da equipa.
class SettingsFooter extends StatelessWidget {
  final String appName;
  final String tagline;

  const SettingsFooter({
    super.key,
    this.appName = 'MovieNight',
    this.tagline = 'Copyright Grupo 02',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Column(
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
              appName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                inherit: false,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            tagline,
            style: TextStyle(
              color: cs.onSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              inherit: false,
            ),
          ),
        ],
      ),
    );
  }
}
