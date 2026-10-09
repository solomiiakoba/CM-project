import 'package:flutter/material.dart';

/// Botão circular reutilizável com acabamento glassmorphic,
/// consistente em todas as vistas e temas (claro e escuro).
class GlassBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final double iconSize;
  final IconData icon;

  const GlassBackButton({
    super.key,
    this.onPressed,
    this.iconColor,
    this.backgroundColor,
    this.borderColor,
    this.iconSize = 16.0,
    this.icon = Icons.arrow_back_ios_new_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    final bg = backgroundColor ??
        (isDark
            ? Colors.black.withValues(alpha: 0.5)
            : Colors.white.withValues(alpha: 0.8));

    final border = borderColor ??
        (isDark ? Colors.white12 : cs.outlineVariant);

    final fg = iconColor ?? cs.onSurface;

    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      splashRadius: 20,
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: Border.all(color: border),
        ),
        child: Icon(
          icon,
          size: iconSize,
          color: fg,
        ),
      ),
      onPressed: onPressed ?? () => Navigator.maybePop(context),
    );
  }
}
