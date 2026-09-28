import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';

class MovieNightPeripheralService {
  final FlutterBlePeripheral _peripheral =
      FlutterBlePeripheral();

  static const String serviceUuid =
      'bf27730d-860a-4e09-889c-2d8b6a9e0fe7';

  /// Dados recebidos de um dispositivo central.
  ///
  /// O central escreve na característica RX
  /// e o plugin disponibiliza os bytes através deste stream.
  Stream<Uint8List> get receivedData {
    return _peripheral.onDataReceived;
  }

  /// Indica se algum central está ligado.
  Future<bool> get isConnected {
    return _peripheral.isConnected;
  }

  /// Indica se algum central está subscrito à característica TX.
  ///
  /// Só depois de existir uma subscrição é que podemos
  /// enviar notificações com sendData().
  Future<bool> get isSubscribed {
    return _peripheral.isSubscribed;
  }

  /// Inicia o anúncio BLE e o servidor GATT.
  Future<String> startAdvertising() async {
    final supported = await _peripheral.isSupported;

    if (!supported) {
      return 'unsupported';
    }

    final permission =
        await _peripheral.requestPermission();

    if (permission != PeripheralBluetoothState.granted &&
        permission != PeripheralBluetoothState.ready) {
      return 'permission: ${permission.name}';
    }

    final result = await _peripheral.start(
      advertiseData: const AdvertiseDataCore(
        serviceUuid: serviceUuid,
      ),
      gattServer: const GattServerSettings(
        serviceUuid: serviceUuid,
      ),
    );

    return result.name;
  }

  /// Para o anúncio BLE.
  Future<void> stopAdvertising() async {
    await _peripheral.stop();
  }

  /// Verifica se o dispositivo está atualmente a anunciar.
  Future<bool> isAdvertising() async {
    return await _peripheral.isAdvertising;
  }

  /// Envia uma mensagem JSON para o central ligado.
  ///
  /// Exemplo:
  /// {
  ///   "type": "test",
  ///   "message": "Olá!"
  /// }
  Future<void> sendMessage(
    Map<String, dynamic> message,
  ) async {
    final subscribed = await _peripheral.isSubscribed;

    if (!subscribed) {
      throw Exception(
        'Nenhum dispositivo está subscrito para receber mensagens.',
      );
    }

    final json = jsonEncode(message);

    final bytes = Uint8List.fromList(
      utf8.encode(json),
    );

    await _peripheral.sendData(bytes);
  }
}
