import 'package:flutter/material.dart';

import 'package:movienight_app/app/theme.dart';

/// Badge translúcido que instrui o participante a apontar a câmara para o código QR do organizador.
class ScannerInstructionBadge extends StatelessWidget {
  final String instruction;

  const ScannerInstructionBadge({
    super.key,
    required this.instruction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.qr_code_scanner_rounded,
            color: MNColors.primaryLight,
            size: 18,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              instruction,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
