import 'package:flutter/material.dart';

/// Barra de navegação / cabeçalho padrão para os ecrãs da feature de filmes.
class MoviePageHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final VoidCallback? onBack;

  const MoviePageHeader({
    super.key,
    required this.title,
    this.trailing,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: cs.onSurface,
            ),
            onPressed: onBack ?? () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: cs.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
