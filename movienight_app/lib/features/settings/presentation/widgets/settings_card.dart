import 'package:flutter/material.dart';

import 'package:movienight_app/shared/widgets/glass_container.dart';

/// Contentor moderno com estilo glassmorphic, totalmente adaptado para temas claro e escuro.
class SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const SettingsCard({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    final dividerColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : cs.outlineVariant.withValues(alpha: 0.5);

    return GlassContainer(
      child: Column(
        children: List.generate(children.length * 2 - 1, (index) {
          if (index.isOdd) {
            return Divider(
              height: 1,
              color: dividerColor,
              indent: 58,
            );
          }
          return children[index ~/ 2];
        }),
      ),
    );
  }
}
