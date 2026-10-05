import 'package:flutter/material.dart';

import 'package:movienight_app/app/theme.dart';

/// Badge visual indicando a quantidade de filtros ativos.
class ActiveFiltersBadge extends StatelessWidget {
  final String label;

  const ActiveFiltersBadge({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MNColors.primary.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.filter_list_rounded,
            size: 14,
            color: MNColors.primaryLight,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: MNColors.primaryLight,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
