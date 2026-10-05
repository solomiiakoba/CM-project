import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../shared/widgets/gradient_action_button.dart';

class HomeActionsSection extends StatelessWidget {
  final String createSessionLabel;
  final String joinSessionLabel;
  final String bluetoothTestLabel;
  final VoidCallback onCreateSession;
  final VoidCallback onJoinSession;
  final VoidCallback onBluetoothTest;

  const HomeActionsSection({
    super.key,
    required this.createSessionLabel,
    required this.joinSessionLabel,
    required this.bluetoothTestLabel,
    required this.onCreateSession,
    required this.onJoinSession,
    required this.onBluetoothTest,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GradientActionButton(
          icon: Icons.add_circle_outline_rounded,
          label: createSessionLabel,
          gradient: const LinearGradient(
            colors: [MNColors.primary, MNColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          padding: EdgeInsets.zero,
          onTap: onCreateSession,
        ),
        const SizedBox(height: 16),
        GradientActionButton(
          icon: Icons.qr_code_scanner_rounded,
          label: joinSessionLabel,
          gradient: const LinearGradient(
            colors: [MNColors.secondary, MNColors.secondaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          padding: EdgeInsets.zero,
          onTap: onJoinSession,
        ),
        const SizedBox(height: 32),
        Center(
          child: TextButton.icon(
            onPressed: onBluetoothTest,
            icon: const Icon(Icons.bluetooth, size: 16),
            label: Text(
              bluetoothTestLabel,
              style: const TextStyle(fontSize: 12),
            ),
            style: TextButton.styleFrom(
              foregroundColor: cs.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
