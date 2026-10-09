import 'package:flutter/material.dart';

import 'package:movienight_app/app/theme.dart';
import 'package:movienight_app/shared/widgets/glass_container.dart';

/// Card visual que indica o estado da difusão Bluetooth BLE através de um ícone com animação pulsante.
class BluetoothStatusCard extends StatelessWidget {
  final bool advertising;
  final AnimationController pulseController;
  final String label;

  const BluetoothStatusCard({
    super.key,
    required this.advertising,
    required this.pulseController,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor =
        advertising ? MNColors.secondary : const Color(0xFFF59E0B);

    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      borderColor: activeColor.withValues(alpha: 0.4),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: pulseController,
            builder: (_, _) {
              final scale = advertising
                  ? 1.0 + pulseController.value * 0.25
                  : 1.0;
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: activeColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    advertising
                        ? Icons.bluetooth_searching_rounded
                        : Icons.bluetooth_disabled_rounded,
                    color: activeColor,
                    size: 20,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: activeColor,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
