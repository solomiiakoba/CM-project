import 'package:flutter/material.dart';

import '../../../../app/theme.dart';

/// Barra de atalhos rápidos com sugestões de nomes para a sessão.
class SessionNamePresetsRow extends StatelessWidget {
  final List<String> presets;
  final ValueChanged<String> onSelectPreset;

  const SessionNamePresetsRow({
    super.key,
    required this.presets,
    required this.onSelectPreset,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: presets.map((preset) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onSelectPreset(preset),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF141724).withValues(alpha: 0.7)
                    : cs.surfaceContainerHighest.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.12)
                      : cs.outlineVariant.withValues(alpha: 0.8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    size: 13,
                    color: isDark ? MNColors.primaryLight : MNColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    preset,
                    style: TextStyle(
                      color: cs.onSurface,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
