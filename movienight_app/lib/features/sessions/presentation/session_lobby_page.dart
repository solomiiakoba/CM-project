import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../bluetooth/data/movie_night_peripheral_service.dart';
import '../domain/session.dart';

class SessionLobbyPage extends StatefulWidget {
  final Session session;

  const SessionLobbyPage({
    super.key,
    required this.session,
  });

  @override
  State<SessionLobbyPage> createState() =>
      _SessionLobbyPageState();
}

class _SessionLobbyPageState
    extends State<SessionLobbyPage> {
  final MovieNightPeripheralService _peripheralService =
      MovieNightPeripheralService();

  StreamSubscription<Uint8List>? _messageSubscription;

  late Session _session;

  bool _advertising = false;
  String? _bluetoothStatus;

  @override
  void initState() {
    super.initState();

    _session = widget.session;

    _listenForBluetoothMessages();
    _startBluetoothAdvertising();
  }

  void _listenForBluetoothMessages() {
    _messageSubscription =
        _peripheralService.receivedData.listen(
      _handleBluetoothMessage,
    );
  }

  void _handleBluetoothMessage(Uint8List data) {
    try {
      final text = utf8.decode(
        data,
        allowMalformed: true,
      );

      debugPrint(
        'LOBBY BLE recebido: $text',
      );

      final decoded = jsonDecode(text);

      if (decoded is! Map) {
        return;
      }

      final type = decoded['type']?.toString();

      if (type != 'join_session') {
        return;
      }

      final sessionId =
          decoded['sessionId']?.toString();

      final participantId =
          decoded['participantId']?.toString();

      debugPrint(
        'LOBBY: join recebido '
        'sessionId=$sessionId '
        'sessionAtual=${_session.id} '
        'participantId=$participantId',
      );

      if (sessionId == null ||
          participantId == null ||
          sessionId.isEmpty ||
          participantId.isEmpty) {
        return;
      }

      if (sessionId != _session.id) {
        debugPrint(
          'LOBBY: sessão diferente. Ignorado.',
        );
        return;
      }

      if (_session.participantIds
          .contains(participantId)) {
        debugPrint(
          'LOBBY: participante já existe.',
        );
        return;
      }

      setState(() {
        _session = _session.copyWith(
          participantIds: [
            ..._session.participantIds,
            participantId,
          ],
        );
      });

      debugPrint(
        'LOBBY: participante adicionado: '
        '$participantId',
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Novo participante entrou.',
          ),
        ),
      );
    } catch (e) {
      debugPrint(
        'LOBBY: erro ao processar BLE: $e',
      );
    }
  }

  Future<void> _startBluetoothAdvertising() async {
    try {
      final result =
          await _peripheralService.startAdvertising();

      debugPrint(
        'LOBBY: advertising result=$result',
      );

      if (!mounted) {
        return;
      }

      if (result == 'granted' ||
          result == 'ready') {
        setState(() {
          _advertising = true;
          _bluetoothStatus =
              'Sessão disponível por Bluetooth';
        });
      } else {
        setState(() {
          _advertising = false;
          _bluetoothStatus =
              'Bluetooth: $result';
        });
      }
    } catch (e) {
      debugPrint(
        'LOBBY: erro ao iniciar advertising: $e',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _advertising = false;
        _bluetoothStatus =
            'Erro no Bluetooth';
      });
    }
  }

  Future<void> _stopBluetoothAdvertising() async {
    try {
      await _peripheralService.stopAdvertising();
    } catch (e) {
      debugPrint(
        'LOBBY: erro ao parar advertising: $e',
      );
    }
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _stopBluetoothAdvertising();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final qrData = jsonEncode({
      'type': 'session_invite',
      'sessionId': _session.id,
      'name': _session.name,
      'createdAt':
          _session.createdAt.toIso8601String(),
      'organizerId': _session.organizerId,
      'participantIds':
          _session.participantIds,
    });

    final participantCount =
        _session.participantIds.length + 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lobby'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                _session.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Junta os teus amigos à Movie Night.',
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _advertising
                        ? Colors.green
                        : Colors.orange,
                  ),
                  borderRadius:
                      BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      _advertising
                          ? Icons.bluetooth
                          : Icons.bluetooth_disabled,
                      color: _advertising
                          ? Colors.green
                          : Colors.orange,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _bluetoothStatus ??
                            'A preparar Bluetooth...',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'Código da sessão',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  _session.id,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                  child: QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 220,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius:
                      BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.people,
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Participantes',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '$participantCount',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const ListTile(
                      contentPadding:
                          EdgeInsets.zero,
                      leading: CircleAvatar(
                        child: Icon(
                          Icons.person,
                        ),
                      ),
                      title: Text('Tu'),
                      subtitle: Text('Organizador'),
                    ),
                    if (_session
                        .participantIds
                        .isEmpty)
                      const Padding(
                        padding:
                            EdgeInsets.only(
                          top: 8,
                        ),
                        child: Text(
                          'Aguardando amigos...',
                        ),
                      ),
                    for (final participantId
                        in _session
                            .participantIds)
                      ListTile(
                        contentPadding:
                            EdgeInsets.zero,
                        leading:
                            const CircleAvatar(
                          child: Icon(
                            Icons.person_outline,
                          ),
                        ),
                        title: const Text(
                          'Participante',
                        ),
                        subtitle: Text(
                          participantId,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      _session.participantIds.isEmpty
                          ? null
                          : () {
                              ScaffoldMessenger
                                  .of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Votação pronta para começar.',
                                  ),
                                ),
                              );
                            },
                  child: const Text(
                    'Começar votação',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
