import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../domain/session.dart';
import '../../bluetooth/presentation/bluetooth_test_page.dart';

class ScanSessionPage extends StatefulWidget {
  const ScanSessionPage({
    super.key,
  });

  @override
  State<ScanSessionPage> createState() =>
      _ScanSessionPageState();
}

class _ScanSessionPageState
    extends State<ScanSessionPage> {
  bool _alreadyScanned = false;

  void _handleBarcode(
    BarcodeCapture capture,
  ) {
    if (_alreadyScanned) {
      return;
    }

    final barcode =
        capture.barcodes.firstOrNull;

    final rawValue =
        barcode?.rawValue;

    if (rawValue == null ||
        rawValue.isEmpty) {
      return;
    }

    try {
      final data =
          jsonDecode(rawValue);

      if (data['type'] != 'session_invite') {
        return;
      }

      final session = Session(
        id: data['sessionId'],
        name: data['name'],
        createdAt:
            DateTime.parse(
          data['createdAt'],
        ),
        organizerId:
            data['organizerId'],
        participantIds:
            List<String>.from(
          data['participantIds'] ?? [],
        ),
      );

      _alreadyScanned = true;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              BluetoothTestPage(
            session: session,
            autoJoin: true,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'QR Code inválido.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Entrar numa sessão',
        ),
      ),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: _handleBarcode,
          ),
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                borderRadius:
                    BorderRadius.circular(20),
              ),
            ),
          ),
          const Positioned(
            left: 24,
            right: 24,
            bottom: 40,
            child: Text(
              'Aponta a câmara para o QR Code da sessão',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
