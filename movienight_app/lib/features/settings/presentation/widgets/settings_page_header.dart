import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class SettingsPageHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const SettingsPageHeader({
    super.key,
    required this.title,
    this.subtitle = 'MovieNight',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [MNColors.primary, MNColors.secondary],
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
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 13,
              inherit: false,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
