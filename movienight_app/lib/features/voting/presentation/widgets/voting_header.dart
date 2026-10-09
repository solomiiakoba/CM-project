import 'package:flutter/material.dart';

import 'package:movienight_app/shared/widgets/glass_back_button.dart';
import 'package:movienight_app/shared/widgets/glass_container.dart';

class VotingHeader extends StatelessWidget {
  final String title;
  final int current;
  final int total;
  final VoidCallback onClose;

  const VotingHeader({
    super.key,
    required this.title,
    required this.current,
    required this.total,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          GlassBackButton(
            icon: Icons.close_rounded,
            onPressed: onClose,
          ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: cs.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          GlassContainer(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            borderRadius: 20,
            child: Text(
              '$current / $total',
              style: TextStyle(
                color: cs.primary,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
