import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:movienight_app/app/theme.dart';
import 'package:movienight_app/core/bluetooth/bluetooth_test_page.dart';
import 'package:movienight_app/features/session/domain/entities/session.dart';
import 'package:movienight_app/l10n/app_localizations.dart';

class ScanSessionPage extends StatefulWidget {
  const ScanSessionPage({super.key});

  @override
  State<ScanSessionPage> createState() => _ScanSessionPageState();
}

class _ScanSessionPageState extends State<ScanSessionPage>
    with SingleTickerProviderStateMixin {
  bool _alreadyScanned = false;
  late AnimationController _scanLineController;

  @override
  void initState() {
    super.initState();
    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanLineController.dispose();
    super.dispose();
  }

  void _handleBarcode(BarcodeCapture capture) {
    if (_alreadyScanned) return;

    final rawValue = capture.barcodes.firstOrNull?.rawValue;
    if (rawValue == null || rawValue.isEmpty) return;

    try {
      final data = jsonDecode(rawValue);
      if (data['type'] != 'session_invite') return;

      // Usa fromJson para incluir os filtros transmitidos no QR
      final sessionData = Map<String, dynamic>.from(data as Map);
      sessionData['id'] = data['sessionId']; // normaliza chave
      final session = Session.fromJson(sessionData);

      _alreadyScanned = true;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              BluetoothTestPage(session: session, autoJoin: true),
        ),
      );
    } catch (_) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.scanSessionError)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Camera ─────────────────────────────────────────────────────
          MobileScanner(onDetect: _handleBarcode),

          // ── Overlay escuro nas bordas ───────────────────────────────────
          _ScannerOverlay(),

          // ── AppBar transparente ─────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded,
                        color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    l10n.scanSessionTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Quadrado de scan ──────────────────────────────────────────
          Center(
            child: SizedBox(
              width: 260,
              height: 260,
              child: Stack(
                children: [
                  // Cantos arredondados
                  CustomPaint(
                    size: const Size(260, 260),
                    painter: _CornerPainter(),
                  ),
                  // Linha de scan animada
                  AnimatedBuilder(
                    animation: _scanLineController,
                    builder: (_, __) {
                      return Positioned(
                        top: _scanLineController.value * 250,
                        left: 4,
                        right: 4,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                MNColors.primary.withOpacity(0.8),
                                MNColors.secondary.withOpacity(0.8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // ── Instrução na base ─────────────────────────────────────────
          Positioned(
            left: 24,
            right: 24,
            bottom: 60,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.15)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.qr_code_scanner_rounded,
                          color: MNColors.primaryLight, size: 18),
                      const SizedBox(width: 10),
                      Text(
                        l10n.scanSessionInstruction,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Overlay com sombra nas bordas
// ─────────────────────────────────────────────────────────────────────────────

class _ScannerOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const holeSize = 260.0;
    final screenSize = MediaQuery.of(context).size;
    final holeLeft = (screenSize.width - holeSize) / 2;
    final holeTop = (screenSize.height - holeSize) / 2;

    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(0.5),
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

// ─────────────────────────────────────────────────────────────────────────────
// Painter dos cantos do quadrado de scan
// ─────────────────────────────────────────────────────────────────────────────

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = MNColors.primaryLight
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const cornerLen = 24.0;
    const r = 12.0;

    // Top-left
    canvas.drawArc(const Rect.fromLTWH(0, 0, r * 2, r * 2),
        3.14, 1.57, false, paint);
    canvas.drawLine(
        const Offset(r, 0), const Offset(r + cornerLen, 0), paint);
    canvas.drawLine(
        const Offset(0, r), const Offset(0, r + cornerLen), paint);

    // Top-right
    final tr = Offset(size.width - r * 2, 0.0);
    canvas.drawArc(
        Rect.fromLTWH(tr.dx, tr.dy, r * 2, r * 2), 4.71, 1.57, false, paint);
    canvas.drawLine(Offset(size.width - r - cornerLen, 0),
        Offset(size.width - r, 0), paint);
    canvas.drawLine(Offset(size.width, r),
        Offset(size.width, r + cornerLen), paint);

    // Bottom-left
    final bl = Offset(0.0, size.height - r * 2);
    canvas.drawArc(
        Rect.fromLTWH(bl.dx, bl.dy, r * 2, r * 2), 1.57, 1.57, false, paint);
    canvas.drawLine(Offset(0, size.height - r - cornerLen),
        Offset(0, size.height - r), paint);
    canvas.drawLine(Offset(r, size.height),
        Offset(r + cornerLen, size.height), paint);

    // Bottom-right
    final br = Offset(size.width - r * 2, size.height - r * 2);
    canvas.drawArc(
        Rect.fromLTWH(br.dx, br.dy, r * 2, r * 2), 0, 1.57, false, paint);
    canvas.drawLine(Offset(size.width - r - cornerLen, size.height),
        Offset(size.width - r, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height - r - cornerLen),
        Offset(size.width, size.height - r), paint);
  }

  @override
  bool shouldRepaint(_CornerPainter old) => false;
}
