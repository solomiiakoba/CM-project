import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:movienight_app/features/session/domain/entities/session.dart';
import 'package:movienight_app/core/bluetooth/bluetooth_test_page.dart';
import 'package:movienight_app/l10n/app_localizations.dart';

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
      final errorText = AppLocalizations.of(context)!.scanSessionError;
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(errorText),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.scanSessionTitle),
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
          Positioned(
            left: 24,
            right: 24,
            bottom: 40,
            child: Text(
              l10n.scanSessionInstruction,
              textAlign: TextAlign.center,
              style: const TextStyle(
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
