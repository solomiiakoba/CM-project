import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class SettingsFooter extends StatelessWidget {
  final String appName;
  final String tagline;

  const SettingsFooter({
    super.key,
    this.appName = 'MovieNight',
    this.tagline = 'Built with Flutter',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [MNColors.primary, MNColors.secondary],
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
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 11,
              inherit: false,
            ),
          ),
        ],
      ),
    );
  }
}
