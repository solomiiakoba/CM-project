import 'package:flutter/material.dart';

import 'package:movienight_app/app/theme.dart';

/// Badge visual que apresenta a quantidade de filmes filtrados ou disponíveis.
class MovieCountBadge extends StatelessWidget {
  final String label;

  const MovieCountBadge({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: MNColors.primaryLight,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
