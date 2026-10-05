import 'package:flutter/material.dart';

import 'package:movienight_app/app/theme.dart';

/// Cabeçalho de secção para agrupar categorias de filtros com informação opcional à direita.
class FilterSectionHeader extends StatelessWidget {
  final String title;
  final String? trailing;

  const FilterSectionHeader({
    super.key,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: cs.onSurface,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: const TextStyle(
              color: MNColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}
