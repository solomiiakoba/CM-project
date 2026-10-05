import 'package:flutter/material.dart';
import '../providers/voting_state.dart';

class VotingGestureIndicators extends StatelessWidget {
  final TiltGesture gesture;
  final String skipLabel;
  final String likeLabel;

  const VotingGestureIndicators({
    super.key,
    required this.gesture,
    required this.skipLabel,
    required this.likeLabel,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final defaultColor = cs.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnimatedOpacity(
            opacity: gesture == TiltGesture.left ? 1.0 : 0.3,
            duration: const Duration(milliseconds: 200),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 14,
                  color: gesture == TiltGesture.left
                      ? const Color(0xFFEF4444)
                      : defaultColor,
                ),
                const SizedBox(width: 4),
                Text(
                  skipLabel,
                  style: TextStyle(
                    color: gesture == TiltGesture.left
                        ? const Color(0xFFEF4444)
                        : defaultColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          AnimatedOpacity(
            opacity: gesture == TiltGesture.right ? 1.0 : 0.3,
            duration: const Duration(milliseconds: 200),
            child: Row(
              children: [
                Text(
                  likeLabel,
                  style: TextStyle(
                    color: gesture == TiltGesture.right
                        ? const Color(0xFF22C55E)
                        : defaultColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: gesture == TiltGesture.right
                      ? const Color(0xFF22C55E)
                      : defaultColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
