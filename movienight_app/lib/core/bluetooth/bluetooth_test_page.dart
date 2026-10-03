import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'bluetooth_service.dart';
import 'movie_night_ble_client.dart';
import '../../shared/utils/participant_identity_service.dart';
import '../../features/session/domain/entities/session.dart';
import '../../features/movies/domain/movie.dart';
import '../../features/voting/presentation/pages/voting_page.dart';
import '../../features/voting/presentation/providers/voting_notifier.dart';

class BluetoothTestPage extends StatefulWidget {
  final Session? session;
  final bool autoJoin;

  const BluetoothTestPage({
    super.key,
    this.session,
    this.autoJoin = false,
  });

  @override
  State<BluetoothTestPage> createState() =>
      _BluetoothTestPageState();
}

class _BluetoothTestPageState
    extends State<BluetoothTestPage> {
  final MovieNightBluetoothService _bluetoothService =
      MovieNightBluetoothService();

  final ParticipantIdentityService _identityService =
      ParticipantIdentityService();

  final MovieNightBleClient _bleClient =
      MovieNightBleClient();

  bool _bluetoothOn = false;
  bool _scanning = false;
  bool _connecting = false;
  bool _joinSent = false;

  String? _participantId;
  String? _connectionStatus;
  String? _lastReceivedMessage;

  List<ScanResult> _devices = [];

  StreamSubscription<Map<String, dynamic>>?
      _messageSubscription;

  @override
  void initState() {
    super.initState();

    _loadIdentity();
    _checkBluetooth();
    _listenForMessages();

    if (widget.autoJoin) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          _autoJoin();
        },
      );
    }
  }

  void _listenForMessages() {
    _messageSubscription =
        _bleClient.messages.listen(
      (message) {
        if (!mounted) return;

        setState(() {
          _lastReceivedMessage =
              message.toString();
        });

        _handleIncomingSessionMessage(message);
      },
    );
  }

  void _handleIncomingSessionMessage(Map<String, dynamic> message) {
    if (message['type'] != 'voting_started') return;

    final sessionId = message['sessionId']?.toString();
    final rawMovies = message['movies'];
    if (sessionId == null || rawMovies is! List || rawMovies.isEmpty) return;

    try {
      final movies = rawMovies
          .map((movie) => Movie.fromJson(
                Map<String, dynamic>.from(movie as Map),
              ))
          .toList();

      _openVoting(sessionId, movies);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível carregar os filmes.')),
      );
    }
  }

  Future<void> _openVoting(String sessionId, List<Movie> movies) async {
    if (_participantId == null) {
      await _loadIdentity();
    }
    if (!mounted || _participantId == null) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VotingPage(
          params: VotingParams(
            sessionId: sessionId,
            movies: movies,
            participantId: _participantId!,
            bleClient: _bleClient,
          ),
        ),
      ),
    );
  }

  Future<void> _loadIdentity() async {
    final id =
        await _identityService
            .getParticipantId();

    if (!mounted) return;

    setState(() {
      _participantId = id;
    });
  }

  Future<void> _checkBluetooth() async {
    final isOn =
        await _bluetoothService
            .isBluetoothOn();

    if (!mounted) return;

    setState(() {
      _bluetoothOn = isOn;
    });
  }

  Future<void> _autoJoin() async {
    if (widget.session == null) {
      return;
    }

    setState(() {
      _connectionStatus =
          'A procurar o organizador...';
    });

    await _scan();

    if (!mounted) {
      return;
    }

    if (_devices.isEmpty) {
      setState(() {
        _connectionStatus =
            'Organizador não encontrado.';
      });

      return;
    }

    await _connect(_devices.first);
  }

  Future<void> _scan() async {
    if (_scanning ||
        _connecting) {
      return;
    }

    setState(() {
      _scanning = true;
      _devices = [];
    });

    try {
      await _bluetoothService
          .startScan();

      await Future.delayed(
        const Duration(
          seconds: 5,
        ),
      );

      final results =
          FlutterBluePlus
              .lastScanResults;

      final uniqueDevices =
          <String, ScanResult>{};

      for (final result in results) {
        final remoteId =
            result.device.remoteId
                .toString();

        uniqueDevices[remoteId] =
            result;
      }

      _devices =
          uniqueDevices.values.toList();

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _connectionStatus =
            'Erro ao procurar dispositivos.';
      });
    } finally {
      await _bluetoothService
          .stopScan();

      if (!mounted) return;

      setState(() {
        _scanning = false;
      });
    }
  }

  Future<void> _connect(
    ScanResult result,
  ) async {
    if (_connecting) {
      return;
    }

    setState(() {
      _connecting = true;
      _connectionStatus =
          'A ligar ao organizador...';
    });

    try {
      await FlutterBluePlus
          .stopScan();

      await Future.delayed(
        const Duration(
          milliseconds: 500,
        ),
      );

      await _bleClient.connect(
        result.device,
      );

      if (!mounted) return;

      setState(() {
        _connectionStatus =
            'Ligado ao organizador.';
      });

      if (widget.autoJoin &&
          widget.session != null) {
        await _joinSession();
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _connectionStatus =
            'Não foi possível ligar.';
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao ligar: $e',
          ),
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _connecting = false;
      });
    }
  }

  Future<void> _joinSession() async {
    if (!_bleClient.isConnected) {
      return;
    }

    if (widget.session == null) {
      return;
    }

    if (_participantId == null) {
      await _loadIdentity();
    }

    if (_participantId == null) {
      return;
    }

    try {
      await _bleClient.sendJoinSession(
        sessionId:
            widget.session!.id,
        participantId:
            _participantId!,
      );

      if (!mounted) return;

      setState(() {
        _joinSent = true;
        _connectionStatus =
            'Entraste na sessão!';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _connectionStatus =
            'Erro ao entrar na sessão.';
      });
    }
  }

  Future<void> _sendPing() async {
    if (!_bleClient.isConnected) {
      return;
    }

    await _bleClient.sendPing();

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'PING enviado.',
        ),
      ),
    );
  }

  Future<void> _disconnect() async {
    await _bleClient.disconnect();

    if (!mounted) return;

    setState(() {
      _connectionStatus =
          'Desligado';
      _joinSent = false;
    });
  }

  String _deviceName(
    ScanResult result,
  ) {
    final name =
        result.device.platformName;

    if (name.isEmpty) {
      return result.device.remoteId
          .toString();
    }

    return '$name (${result.device.remoteId})';
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _bleClient.disconnect();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isConnected =
        _bleClient.isConnected;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.session?.name ??
              'Teste Bluetooth',
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(24),
        child: Column(
          children: [
            if (widget.session != null)
              Text(
                widget.session!.name,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight:
                      FontWeight.bold,
                ),
                textAlign:
                    TextAlign.center,
              ),

            const SizedBox(height: 24),

            Icon(
              _bluetoothOn
                  ? Icons.bluetooth
                  : Icons.bluetooth_disabled,
              size: 64,
            ),

            const SizedBox(height: 16),

            Text(
              _connectionStatus ??
                  'A preparar...',
              textAlign:
                  TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            if (_participantId != null &&
                widget.autoJoin)
              SelectableText(
                _participantId!,
                textAlign:
                    TextAlign.center,
              ),

            const SizedBox(height: 24),

            if (widget.autoJoin &&
                _joinSent)
              const Column(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 64,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Entraste na sessão!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),

            if (!widget.autoJoin) ...[
              SizedBox(
                width: double.infinity,
                child:
                    ElevatedButton.icon(
                  onPressed:
                      _scanning ||
                              _connecting
                          ? null
                          : _scan,
                  icon:
                      const Icon(
                    Icons.search,
                  ),
                  label: Text(
                    _scanning
                        ? 'A procurar...'
                        : 'Procurar dispositivos',
                  ),
                ),
              ),

              const SizedBox(height: 16),

              if (isConnected)
                SizedBox(
                  width:
                      double.infinity,
                  child:
                      ElevatedButton.icon(
                    onPressed:
                        _sendPing,
                    icon:
                        const Icon(
                      Icons.send,
                    ),
                    label:
                        const Text(
                      'Enviar PING',
                    ),
                  ),
                ),
            ],

            if (isConnected) ...[
              const SizedBox(height: 12),
              SizedBox(
                width:
                    double.infinity,
                child:
                    OutlinedButton.icon(
                  onPressed:
                      _disconnect,
                  icon:
                      const Icon(
                    Icons.bluetooth_disabled,
                  ),
                  label:
                      const Text(
                    'Desligar',
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            if (!widget.autoJoin &&
                _devices.isNotEmpty)
              Expanded(
                child:
                    ListView.builder(
                  itemCount:
                      _devices.length,
                  itemBuilder:
                      (context, index) {
                    final result =
                        _devices[index];

                    return Card(
                      child: ListTile(
                        leading:
                            const Icon(
                          Icons.bluetooth,
                        ),
                        title:
                            Text(
                          _deviceName(
                            result,
                          ),
                        ),
                        subtitle:
                            Text(
                          'RSSI: '
                          '${result.rssi} dBm',
                        ),
                        trailing:
                            ElevatedButton(
                          onPressed:
                              _connecting
                                  ? null
                                  : () =>
                                      _connect(
                                        result,
                                      ),
                          child:
                              const Text(
                            'Ligar',
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
