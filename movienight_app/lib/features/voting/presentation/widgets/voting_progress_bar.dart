import 'package:flutter/material.dart';

class VotingProgressBar extends StatelessWidget {
  final int progress;
  final int total;

  const VotingProgressBar({
    super.key,
    required this.progress,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final value = total > 0 ? progress / total : 0.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: value,
          minHeight: 4,
          backgroundColor: cs.outlineVariant,
          valueColor: AlwaysStoppedAnimation(cs.primary),
        ),
      ),
    );
  }
}
