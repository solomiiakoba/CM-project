import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';

class MovieNightPeripheralService {
  final FlutterBlePeripheral _peripheral = FlutterBlePeripheral();

  static const String serviceUuid = 'bf27730d-860a-4e09-889c-2d8b6a9e0fe7';

  // BLE MTU típico é 20 bytes por notificação sem negociação.
  // Usamos 180 bytes por chunk (margem segura com MTU 185).
  static const int _chunkSize = 180;

  // ── Streams ──────────────────────────────────────────────────────────────

  /// Dados escritos por um central na característica RX.
  Stream<Uint8List> get receivedData => _peripheral.onDataReceived;

  /// True se algum central está ligado.
  Future<bool> get isConnected => _peripheral.isConnected;

  /// True se algum central está subscrito à TX (pronto para notificações).
  Future<bool> get isSubscribed => _peripheral.isSubscribed;

  // ── Advertising ──────────────────────────────────────────────────────────

  Future<String> startAdvertising() async {
    final supported = await _peripheral.isSupported;
    if (!supported) return 'unsupported';

    final permission = await _peripheral.requestPermission();
    if (permission != PeripheralBluetoothState.granted &&
        permission != PeripheralBluetoothState.ready) {
      return 'permission: ${permission.name}';
    }

    final result = await _peripheral.start(
      advertiseData: const AdvertiseDataCore(serviceUuid: serviceUuid),
      gattServer: const GattServerSettings(serviceUuid: serviceUuid),
    );
    return result.name;
  }

  Future<void> stopAdvertising() async => _peripheral.stop();

  Future<bool> isAdvertising() async => _peripheral.isAdvertising;

  // ── Envio ────────────────────────────────────────────────────────────────

  /// Envia uma mensagem JSON para todos os centrais subscritos.
  ///
  /// Mensagens maiores que [_chunkSize] são automaticamente partidas em
  /// chunks com envelope:
  ///   {"_chunk": <index>, "_total": <n>, "_data": "<base64_slice>"}
  ///
  /// O receptor deve reassemblar antes de fazer jsonDecode.
  Future<void> sendMessage(Map<String, dynamic> message) async {
    final subscribed = await _peripheral.isSubscribed;
    if (!subscribed) {
      throw Exception('Nenhum dispositivo subscrito para receber mensagens.');
    }

    final json = jsonEncode(message);
    final bytes = utf8.encode(json);

    if (bytes.length <= _chunkSize) {
      // Mensagem cabe num único pacote
      await _peripheral.sendData(Uint8List.fromList(bytes));
      debugPrint('BLE PERIPH: enviado ${bytes.length} bytes (1 chunk)');
      return;
    }

    // Partir em chunks com envelope JSON
    final totalChunks = (bytes.length / _chunkSize).ceil();
    debugPrint(
        'BLE PERIPH: enviando ${bytes.length} bytes em $totalChunks chunks');

    for (int i = 0; i < totalChunks; i++) {
      final start = i * _chunkSize;
      final end = (start + _chunkSize).clamp(0, bytes.length);
      final slice = bytes.sublist(start, end);

      final envelope = jsonEncode({
        '_chunk': i,
        '_total': totalChunks,
        '_data': base64Encode(slice),
      });

      await _peripheral.sendData(
          Uint8List.fromList(utf8.encode(envelope)));

      // Pausa entre chunks para não saturar o buffer BLE
      if (i < totalChunks - 1) {
        await Future.delayed(const Duration(milliseconds: 30));
      }
    }
  }
}
