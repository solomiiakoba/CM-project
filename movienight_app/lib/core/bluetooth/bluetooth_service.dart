import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class MovieNightBluetoothService {
  static const String movieNightServiceUuid =
      'bf27730d-860a-4e09-889c-2d8b6a9e0fe7';

  Future<bool> isBluetoothOn() async {
    return await FlutterBluePlus.adapterState.first ==
        BluetoothAdapterState.on;
  }

  Future<void> startScan() async {
    await FlutterBluePlus.startScan(
      withServices: [
        Guid(movieNightServiceUuid),
      ],
      timeout: const Duration(seconds: 5),
    );
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }
}
