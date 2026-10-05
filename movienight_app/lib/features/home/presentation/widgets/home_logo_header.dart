import 'package:flutter/material.dart';

import '../../../../app/theme.dart';

class HomeLogoHeader extends StatelessWidget {
  final String title;
  final String description;

  const HomeLogoHeader({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [MNColors.primary, MNColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: MNColors.primary.withValues(alpha: 0.5),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.movie_filter_rounded,
            color: Colors.white,
            size: 36,
          ),
        ),
        const SizedBox(height: 28),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [MNColors.primaryLight, MNColors.secondary],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(bounds),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              height: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
