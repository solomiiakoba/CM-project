import 'package:flutter/material.dart';

class VotingActionButtons extends StatelessWidget {
  final String skipLabel;
  final String likeLabel;
  final bool isAnimating;
  final VoidCallback onSkip;
  final VoidCallback onLike;

  const VotingActionButtons({
    super.key,
    required this.skipLabel,
    required this.likeLabel,
    required this.isAnimating,
    required this.onSkip,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: _VoteButton(
              icon: Icons.close_rounded,
              label: skipLabel,
              color: const Color(0xFFEF4444),
              filled: false,
              onTap: isAnimating ? null : onSkip,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _VoteButton(
              icon: Icons.favorite_rounded,
              label: likeLabel,
              color: const Color(0xFF22C55E),
              filled: true,
              onTap: isAnimating ? null : onLike,
            ),
          ),
        ],
      ),
    );
  }
}

class _VoteButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool filled;
  final VoidCallback? onTap;

  const _VoteButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.filled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: onTap == null ? 0.4 : 1.0,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: filled ? color.withValues(alpha: 0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.6), width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
