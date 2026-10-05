import 'package:flutter/material.dart';

class VoteGestureOverlay extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Alignment alignment;

  const VoteGestureOverlay({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Transform.rotate(
            angle: alignment == Alignment.topLeft ? -0.3 : 0.3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                border: Border.all(color: color, width: 2.5),
                borderRadius: BorderRadius.circular(10),
                color: color.withValues(alpha: 0.08),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: color, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
