import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:movienight_app/app/theme.dart';

/// Card que renderiza o QR Code ótico num contentor de alto contraste e o código da sessão formatado.
class QrCodeCard extends StatelessWidget {
  final String qrData;
  final String sessionId;
  final String sessionCodeLabel;

  const QrCodeCard({
    super.key,
    required this.qrData,
    required this.sessionId,
    required this.sessionCodeLabel,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: MNColors.primary.withValues(alpha: 0.12),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // QR sempre em fundo branco para contraste garantido na leitura ótica
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 200,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            sessionCodeLabel,
            style: TextStyle(
              color: cs.onSurfaceVariant,
              fontSize: 12,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          ShaderMask(
            shaderCallback: (b) => const LinearGradient(
              colors: [MNColors.primaryLight, MNColors.secondary],
            ).createShader(b),
            child: Text(
              sessionId,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
