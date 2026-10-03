import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class MovieNightBleClient {
  static const String serviceUuid =
      'bf27730d-860a-4e09-889c-2d8b6a9e0fe7';

  // UUIDs usados pelo flutter_ble_peripheral.
  static const String rxCharacteristicUuid =
      '6e400002-b5a3-f393-e0a9-e50e24dcca9e';

  static const String txCharacteristicUuid =
      '6e400003-b5a3-f393-e0a9-e50e24dcca9e';

  BluetoothDevice? _connectedDevice;

  BluetoothCharacteristic? _rxCharacteristic;
  BluetoothCharacteristic? _txCharacteristic;

  StreamSubscription<List<int>>?
      _notificationSubscription;

  final StreamController<Map<String, dynamic>>
      _messageController =
      StreamController<Map<String, dynamic>>.broadcast();

  final Map<int, Map<int, List<int>>> _chunkBuffers = {};

  BluetoothDevice? get connectedDevice =>
      _connectedDevice;

  bool get isConnected =>
      _connectedDevice != null;

  Stream<Map<String, dynamic>> get messages =>
      _messageController.stream;

  // ==========================================================
  // CONNECT
  // ==========================================================

  Future<void> connect(
    BluetoothDevice device,
  ) async {
    if (_connectedDevice != null) {
      await disconnect();
    }

    debugPrint(
      'BLE: a preparar ligação a ${device.remoteId}',
    );

    // Pequena pausa para o Android terminar o scan.
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    debugPrint(
      'BLE: a ligar a ${device.remoteId}',
    );

    await device.connect(
      timeout: const Duration(seconds: 15),
      license: License.free,
    );

    _connectedDevice = device;

    debugPrint(
      'BLE: ligação estabelecida.',
    );

    final services =
        await device.discoverServices();

    debugPrint(
      'BLE: ${services.length} serviços encontrados.',
    );

    BluetoothService? movieNightService;

    for (final service in services) {
      debugPrint(
        'BLE service encontrado: ${service.uuid}',
      );

      if (service.uuid == Guid(serviceUuid)) {
        movieNightService = service;
        break;
      }
    }

    if (movieNightService == null) {
      await disconnect();

      throw Exception(
        'Serviço MovieNight não encontrado.',
      );
    }

    debugPrint(
      'BLE: serviço MovieNight encontrado: '
      '${movieNightService.uuid}',
    );

    BluetoothCharacteristic? rx;
    BluetoothCharacteristic? tx;

    // Procurar explicitamente as characteristics
    // usadas pelo flutter_ble_peripheral.
    for (final characteristic
        in movieNightService.characteristics) {
      debugPrint(
        'BLE characteristic: '
        '${characteristic.uuid} | '
        'read=${characteristic.properties.read} | '
        'write=${characteristic.properties.write} | '
        'writeWithoutResponse='
        '${characteristic.properties.writeWithoutResponse} | '
        'notify=${characteristic.properties.notify} | '
        'indicate=${characteristic.properties.indicate}',
      );

      final uuid =
          characteristic.uuid.toString().toLowerCase();

      if (uuid == rxCharacteristicUuid) {
        rx = characteristic;

        debugPrint(
          'BLE: RX encontrada: ${characteristic.uuid}',
        );
      }

      if (uuid == txCharacteristicUuid) {
        tx = characteristic;

        debugPrint(
          'BLE: TX encontrada: ${characteristic.uuid}',
        );
      }
    }

    if (rx == null) {
      await disconnect();

      throw Exception(
        'Characteristic RX não encontrada: '
        '$rxCharacteristicUuid',
      );
    }

    if (tx == null) {
      await disconnect();

      throw Exception(
        'Characteristic TX não encontrada: '
        '$txCharacteristicUuid',
      );
    }

    _rxCharacteristic = rx;
    _txCharacteristic = tx;

    debugPrint(
      'BLE RX escolhida: '
      '${_rxCharacteristic!.uuid}',
    );

    debugPrint(
      'BLE TX escolhida: '
      '${_txCharacteristic!.uuid}',
    );

    debugPrint(
      'BLE TX properties: '
      'notify=${_txCharacteristic!.properties.notify}, '
      'indicate=${_txCharacteristic!.properties.indicate}',
    );

    if (!_txCharacteristic!.properties.notify &&
        !_txCharacteristic!.properties.indicate) {
      await disconnect();

      throw Exception(
        'A TX não suporta notify nem indicate.',
      );
    }

    // Ativar notificações.
    debugPrint(
      'BLE: a ativar notificações na TX '
      '${_txCharacteristic!.uuid}',
    );

    await _txCharacteristic!.setNotifyValue(true);

    debugPrint(
      'BLE: notificações TX ativadas.',
    );

    _notificationSubscription =
        _txCharacteristic!.lastValueStream.listen(
      (data) {
        debugPrint(
          'BLE NOTIFICATION RECEBIDA: $data',
        );

        _handleIncomingData(data);
      },
    );

    debugPrint(
      'BLE: listener de notificações iniciado.',
    );
  }

  // ==========================================================
  // RECEBER DADOS
  // ==========================================================

  void _handleIncomingData(
    List<int> data,
  ) {
    if (data.isEmpty) {
      debugPrint(
        'BLE: notification recebida mas está vazia.',
      );

      return;
    }

    debugPrint(
      'BLE: processando ${data.length} bytes.',
    );

    try {
      final text = utf8.decode(data, allowMalformed: true);
      final decoded = jsonDecode(text);

      if (decoded is Map &&
          decoded['_chunk'] is num &&
          decoded['_total'] is num &&
          decoded['_data'] is String) {
        _handleChunk(decoded);
        return;
      }

      _emitMessage(decoded);
    } catch (e) {
      debugPrint(
        'BLE: erro ao processar mensagem: $e',
      );

      debugPrint(
        'BLE dados recebidos: $data',
      );
    }
  }

  void _handleChunk(Map decoded) {
    final index = (decoded['_chunk'] as num).toInt();
    final total = (decoded['_total'] as num).toInt();
    if (index < 0 || total <= 0 || index >= total) return;

    final buffer = _chunkBuffers.putIfAbsent(total, () => {});
    buffer[index] = base64Decode(decoded['_data'] as String);
    if (buffer.length != total) return;

    final bytes = <int>[];
    for (var i = 0; i < total; i++) {
      final chunk = buffer[i];
      if (chunk == null) return;
      bytes.addAll(chunk);
    }
    _chunkBuffers.remove(total);

    final decodedMessage = jsonDecode(utf8.decode(bytes, allowMalformed: true));
    _emitMessage(decodedMessage);
  }

  void _emitMessage(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      _messageController.add(decoded);
    } else if (decoded is Map) {
      _messageController.add(Map<String, dynamic>.from(decoded));
    } else {
      debugPrint('BLE: JSON recebido não é um Map.');
    }
  }

  // ==========================================================
  // ENVIAR MENSAGEM GENÉRICA
  // ==========================================================

  Future<void> sendMessage(
    Map<String, dynamic> message,
  ) async {
    if (_rxCharacteristic == null) {
      throw Exception(
        'Nenhuma característica RX disponível.',
      );
    }

    final json = jsonEncode(message);

    final bytes = Uint8List.fromList(
      utf8.encode(json),
    );

    debugPrint(
      'BLE: a enviar mensagem:',
    );

    debugPrint(json);

    debugPrint(
      'BLE: ${bytes.length} bytes',
    );

    debugPrint(
      'BLE RX: ${_rxCharacteristic!.uuid}',
    );

    final withoutResponse =
        _rxCharacteristic!
                .properties
                .writeWithoutResponse &&
            !_rxCharacteristic!
                .properties
                .write;

    debugPrint(
      'BLE: withoutResponse=$withoutResponse',
    );

    await _rxCharacteristic!.write(
      bytes,
      withoutResponse: withoutResponse,
    );

    debugPrint(
      'BLE: mensagem enviada com sucesso.',
    );
  }

  // ==========================================================
  // PING
  // ==========================================================

  Future<void> sendPing() async {
    await sendMessage({
      'type': 'ping',
      'message': 'Olá do MovieNight!',
      'timestamp':
          DateTime.now().toIso8601String(),
    });
  }

  // ==========================================================
  // JOIN SESSION
  // ==========================================================

  Future<void> sendJoinSession({
    required String sessionId,
    required String participantId,
  }) async {
    await sendMessage({
      'type': 'join_session',
      'sessionId': sessionId,
      'participantId': participantId,
      'timestamp':
          DateTime.now().toIso8601String(),
    });
  }

  // ==========================================================
  // ENCONTRAR SERVIÇO
  // ==========================================================

  Future<BluetoothService>
      findMovieNightService() async {
    if (_connectedDevice == null) {
      throw Exception(
        'Nenhum dispositivo está ligado.',
      );
    }

    final services =
        await _connectedDevice!.discoverServices();

    for (final service in services) {
      debugPrint(
        'BLE service: ${service.uuid}',
      );

      if (service.uuid == Guid(serviceUuid)) {
        return service;
      }
    }

    throw Exception(
      'Serviço MovieNight não encontrado.',
    );
  }

  // ==========================================================
  // DISCONNECT
  // ==========================================================

  Future<void> disconnect() async {
    debugPrint(
      'BLE: a desligar...',
    );

    await _notificationSubscription?.cancel();

    _notificationSubscription = null;

    _rxCharacteristic = null;
    _txCharacteristic = null;
    _chunkBuffers.clear();

    if (_connectedDevice != null) {
      try {
        await _connectedDevice!.disconnect();
      } catch (_) {
        // O dispositivo pode já estar desligado.
      }
    }

    _connectedDevice = null;

    debugPrint(
      'BLE: desligado.',
    );
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  Future<void> dispose() async {
    await disconnect();

    await _messageController.close();
  }
}
