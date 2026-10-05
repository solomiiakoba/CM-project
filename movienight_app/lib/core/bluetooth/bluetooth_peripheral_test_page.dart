import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'movie_night_peripheral_service.dart';

class BluetoothPeripheralTestPage extends StatefulWidget {
  const BluetoothPeripheralTestPage({
    super.key,
  });

  @override
  State<BluetoothPeripheralTestPage> createState() =>
      _BluetoothPeripheralTestPageState();
}

class _BluetoothPeripheralTestPageState
    extends State<BluetoothPeripheralTestPage> {
  final MovieNightPeripheralService _service =
      MovieNightPeripheralService();

  bool _advertising = false;
  bool _loading = false;
  bool _connected = false;

  String? _lastReceivedMessage;

  StreamSubscription<List<int>>? _dataSubscription;

  @override
  void initState() {
    super.initState();

    _listenForMessages();
  }

  void _listenForMessages() {
    _dataSubscription =
        _service.receivedData.listen((data) {
      final message = utf8.decode(
        data,
        allowMalformed: true,
      );

      if (!mounted) return;

      setState(() {
        _lastReceivedMessage = message;
        _connected = true;
      });

      debugPrint(
        'BLE mensagem recebida: $message',
      );
    });
  }

  Future<void> _toggleAdvertising() async {
    setState(() {
      _loading = true;
    });

    try {
      if (_advertising) {
        await _service.stopAdvertising();

        if (!mounted) return;

        setState(() {
          _advertising = false;
          _connected = false;
        });

        return;
      }

      final result = await _service.startAdvertising();

      if (!mounted) return;

      if (result == 'granted' || result == 'ready') {
        setState(() {
          _advertising = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Peripheral não iniciou. Estado: $result',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _sendTestMessage() async {
    try {
      await _service.sendMessage({
        'type': 'test',
        'message': 'Olá do MovieNight!',
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Mensagem enviada.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao enviar mensagem: $e',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _dataSubscription?.cancel();
    _service.stopAdvertising();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bluetooth Peripheral',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.bluetooth,
              size: 80,
            ),

            const SizedBox(height: 24),

            Text(
              _advertising
                  ? 'MovieNight está visível por Bluetooth'
                  : 'MovieNight não está a anunciar',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              _advertising
                  ? 'Este dispositivo está a anunciar o serviço BLE.'
                  : 'Carrega no botão para anunciar este dispositivo.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            if (_connected) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.green,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.bluetooth_connected,
                      color: Colors.green,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Dispositivo ligado por BLE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],

            if (_lastReceivedMessage != null) ...[
              const Text(
                'Última mensagem recebida:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SelectableText(
                  _lastReceivedMessage!,
                ),
              ),

              const SizedBox(height: 16),
            ],

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _loading
                    ? null
                    : _toggleAdvertising,
                icon: Icon(
                  _advertising
                      ? Icons.stop
                      : Icons.bluetooth_searching,
                ),
                label: Text(
                  _loading
                      ? 'A processar...'
                      : _advertising
                          ? 'Parar anúncio'
                          : 'Anunciar dispositivo',
                ),
              ),
            ),

            const SizedBox(height: 12),

            if (_advertising)
              OutlinedButton.icon(
                onPressed: _sendTestMessage,
                icon: const Icon(
                  Icons.send,
                ),
                label: const Text(
                  'Enviar mensagem de teste',
                ),
              ),

            const SizedBox(height: 24),

            const Divider(),

            const SizedBox(height: 12),

            const Text(
              'Serviço BLE',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const SelectableText(
              'bf27730d-860a-4e09-889c-2d8b6a9e0fe7',
            ),
          ],
        ),
      ),
    );
  }
}
