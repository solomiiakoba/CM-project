import 'package:flutter/material.dart';

import 'package:movienight_app/app/theme.dart';

/// Chip de seleção animado com suporte a ícones e estilos consistentes nos temas claro e escuro.
class FilterChipItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  const FilterChipItem({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = selected
        ? (isDark ? MNColors.primaryContainer : const Color(0xFFEDE9FE))
        : cs.surfaceContainerHighest;
    final borderColor = selected ? MNColors.primary : cs.outlineVariant;
    final textColor = selected ? MNColors.primaryLight : cs.onSurface;
    final iconColor = selected ? MNColors.primaryLight : cs.onSurfaceVariant;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: icon != null ? 10 : 12,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderColor,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 13, color: iconColor),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
