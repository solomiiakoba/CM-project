import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:movienight_app/app/theme.dart';
import 'package:movienight_app/core/bluetooth/bluetooth_test_page.dart';
import 'package:movienight_app/features/session/domain/exceptions/session_exceptions.dart';
import 'package:movienight_app/features/session/domain/usecases/parse_qr_session_usecase.dart';
import 'package:movienight_app/features/session/presentation/widgets/scanner_corner_painter.dart';
import 'package:movienight_app/features/session/presentation/widgets/scanner_instruction_badge.dart';
import 'package:movienight_app/features/session/presentation/widgets/scanner_overlay.dart';
import 'package:movienight_app/l10n/app_localizations.dart';
import 'package:movienight_app/shared/widgets/glass_back_button.dart';

/// Ecrã de leitura ótica (câmara) do código QR de convite para a sessão MovieNight.
class ScanSessionPage extends StatefulWidget {
  const ScanSessionPage({super.key});

  @override
  State<ScanSessionPage> createState() => _ScanSessionPageState();
}

class _ScanSessionPageState extends State<ScanSessionPage>
    with SingleTickerProviderStateMixin {
  bool _alreadyScanned = false;
  late AnimationController _scanLineController;
  final ParseQrSessionUseCase _parseQrSessionUseCase = const ParseQrSessionUseCase();

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
      final session = _parseQrSessionUseCase.execute(rawValue);
      _alreadyScanned = true;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BluetoothTestPage(session: session, autoJoin: true),
        ),
      );
    } on SessionException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
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
          // ── Leitor de Câmara ──────────────────────────────────────────
          MobileScanner(onDetect: _handleBarcode),

          // ── Máscara de recorte central ────────────────────────────────
          const ScannerOverlay(holeSize: 260),

          // ── AppBar transparente ───────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  GlassBackButton(
                    iconColor: Colors.white,
                    backgroundColor: Colors.black.withValues(alpha: 0.5),
                    borderColor: Colors.white24,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 14),
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

          // ── Retângulo do Viewfinder ───────────────────────────────────
          Center(
            child: SizedBox(
              width: 260,
              height: 260,
              child: Stack(
                children: [
                  // Cantos neon arredondados
                  const CustomPaint(
                    size: Size(260, 260),
                    painter: ScannerCornerPainter(),
                  ),
                  // Linha animada de varrimento laser
                  AnimatedBuilder(
                    animation: _scanLineController,
                    builder: (_, _) {
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
                                MNColors.primary.withValues(alpha: 0.8),
                                MNColors.secondary.withValues(alpha: 0.8),
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

          // ── Instrução inferior ────────────────────────────────────────
          Positioned(
            left: 24,
            right: 24,
            bottom: 60,
            child: ScannerInstructionBadge(
              instruction: l10n.scanSessionInstruction,
            ),
          ),
        ],
      ),
    );
  }
}
