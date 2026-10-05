import 'package:flutter/material.dart';

import 'package:movienight_app/app/theme.dart';

/// CustomPainter para renderizar cantos arredondados com stroke estilizado em volta do viewfinder.
class ScannerCornerPainter extends CustomPainter {
  final Color color;
  final double cornerLength;
  final double radius;
  final double strokeWidth;

  const ScannerCornerPainter({
    this.color = MNColors.primaryLight,
    this.cornerLength = 24.0,
    this.radius = 12.0,
    this.strokeWidth = 3.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final r = radius;
    final cornerLen = cornerLength;

    // Canto superior esquerdo
    canvas.drawArc(
      Rect.fromLTWH(0, 0, r * 2, r * 2),
      3.14159,
      1.57079,
      false,
      paint,
    );
    canvas.drawLine(Offset(r, 0), Offset(r + cornerLen, 0), paint);
    canvas.drawLine(Offset(0, r), Offset(0, r + cornerLen), paint);

    // Canto superior direito
    final tr = Offset(size.width - r * 2, 0.0);
    canvas.drawArc(
      Rect.fromLTWH(tr.dx, tr.dy, r * 2, r * 2),
      4.71238,
      1.57079,
      false,
      paint,
    );
    canvas.drawLine(Offset(size.width - r - cornerLen, 0), Offset(size.width - r, 0), paint);
    canvas.drawLine(Offset(size.width, r), Offset(size.width, r + cornerLen), paint);

    // Canto inferior esquerdo
    final bl = Offset(0.0, size.height - r * 2);
    canvas.drawArc(
      Rect.fromLTWH(bl.dx, bl.dy, r * 2, r * 2),
      1.57079,
      1.57079,
      false,
      paint,
    );
    canvas.drawLine(Offset(0, size.height - r - cornerLen), Offset(0, size.height - r), paint);
    canvas.drawLine(Offset(r, size.height), Offset(r + cornerLen, size.height), paint);

    // Canto inferior direito
    final br = Offset(size.width - r * 2, size.height - r * 2);
    canvas.drawArc(
      Rect.fromLTWH(br.dx, br.dy, r * 2, r * 2),
      0,
      1.57079,
      false,
      paint,
    );
    canvas.drawLine(Offset(size.width - r - cornerLen, size.height), Offset(size.width - r, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height - r - cornerLen), Offset(size.width, size.height - r), paint);
  }

  @override
  bool shouldRepaint(ScannerCornerPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.cornerLength != cornerLength ||
      oldDelegate.radius != radius ||
      oldDelegate.strokeWidth != strokeWidth;
}
