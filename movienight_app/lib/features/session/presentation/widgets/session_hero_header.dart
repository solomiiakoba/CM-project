import 'package:flutter/material.dart';

import 'package:movienight_app/app/theme.dart';

/// Cabeçalho herói com ícone gradiente, tipografia estilizada com ShaderMask e subtítulo.
class SessionHeroHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const SessionHeroHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [MNColors.primary, MNColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: MNColors.primary.withValues(alpha: 0.45),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 20),
        ShaderMask(
          shaderCallback: (b) => const LinearGradient(
            colors: [MNColors.primaryLight, MNColors.secondary],
          ).createShader(b),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.3,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            color: cs.onSurfaceVariant,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
