import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Renderiza o fluxo de vídeo da câmara em tempo real para ancoragem em Realidade Aumentada
/// ou um fundo de estúdio imersivo caso selecionado pelo utilizador ou se a câmara não estiver disponível.
class ArCameraViewfinder extends StatelessWidget {
  final bool isStudioMode;

  const ArCameraViewfinder({
    super.key,
    this.isStudioMode = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isStudioMode) {
      return _buildStudioBackground();
    }

    return Positioned.fill(
      child: MobileScanner(
        errorBuilder: (context, error) => _buildStudioBackground(),
      ),
    );
  }

  Widget _buildStudioBackground() {
    return Positioned.fill(
      child: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.25,
            colors: [
              Color(0xFF1E2235),
              Color(0xFF0F111C),
              Color(0xFF06070B),
            ],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.blur_on_rounded,
                color: Colors.white24,
                size: 56,
              ),
              SizedBox(height: 12),
              Text(
                'Modo Estúdio Holográfico Ativo',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
