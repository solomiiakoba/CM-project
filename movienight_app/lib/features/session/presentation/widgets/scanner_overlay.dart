import 'package:flutter/material.dart';

/// Overlay que escurece a visualização da câmara criando um recorte central transparente arredondado.
class ScannerOverlay extends StatelessWidget {
  final double holeSize;

  const ScannerOverlay({
    super.key,
    this.holeSize = 260.0,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final holeLeft = (screenSize.width - holeSize) / 2;
    final holeTop = (screenSize.height - holeSize) / 2;

    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.black.withValues(alpha: 0.5),
        BlendMode.srcOut,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              backgroundBlendMode: BlendMode.dstOut,
            ),
          ),
          Positioned(
            left: holeLeft,
            top: holeTop,
            child: Container(
              width: holeSize,
              height: holeSize,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
