import 'package:flutter/material.dart';

import 'package:movienight_app/app/theme.dart';

/// Botão de ação global com gradiente da aplicação e suporte a estado de carregamento.
class GradientActionButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isLoading;
  final EdgeInsetsGeometry padding;
  final Gradient? gradient;

  const GradientActionButton({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.isLoading = false,
    this.padding = const EdgeInsets.fromLTRB(20, 0, 20, 16),
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null || isLoading;

    return Padding(
      padding: padding,
      child: GestureDetector(
        onTap: isDisabled ? null : onTap,
        child: AnimatedOpacity(
          opacity: isDisabled ? 0.6 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: gradient ??
                  const LinearGradient(
                    colors: [MNColors.primary, MNColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: MNColors.primary.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                else ...[
                  if (icon != null) ...[
                    Icon(icon, color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
