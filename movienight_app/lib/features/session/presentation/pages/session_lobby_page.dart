import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:movienight_app/app/theme.dart';
import 'package:movienight_app/core/bluetooth/movie_night_peripheral_service.dart';
import 'package:movienight_app/features/movies/presentation/pages/movie_filters_page.dart';
import 'package:movienight_app/features/voting/data/voting_repository_impl.dart';
import 'package:movienight_app/features/voting/domain/entities/vote.dart';
import 'package:movienight_app/features/session/domain/entities/session.dart';
import 'package:movienight_app/l10n/app_localizations.dart';
import 'package:movienight_app/shared/widgets/particle_background.dart';

class SessionLobbyPage extends StatefulWidget {
  final Session session;

  const SessionLobbyPage({
    super.key,
    required this.session,
  });

  @override
  State<SessionLobbyPage> createState() => _SessionLobbyPageState();
}

class _SessionLobbyPageState extends State<SessionLobbyPage>
    with SingleTickerProviderStateMixin {
  final MovieNightPeripheralService _peripheralService =
      MovieNightPeripheralService();

  StreamSubscription<Uint8List>? _messageSubscription;
  late AnimationController _pulseController;
  late Session _session;
  bool _advertising = false;

  @override
  void initState() {
    super.initState();
    _session = widget.session;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _listenForBluetoothMessages();
    _startBluetoothAdvertising();
  }

  void _listenForBluetoothMessages() {
    _messageSubscription =
        _peripheralService.receivedData.listen(_handleBluetoothMessage);
  }

  void _handleBluetoothMessage(Uint8List data) {
    try {
      final text = utf8.decode(data, allowMalformed: true);
      final decoded = jsonDecode(text);
      if (decoded is! Map) return;

      final type = decoded['type']?.toString();
      if (type == 'vote_cast') {
        _handleVoteMessage(decoded);
        return;
      }
      if (type == 'request_votes') {
        _sendExistingVotes(decoded['sessionId']?.toString());
        return;
      }
      if (type != 'join_session') return;

      final sessionId = decoded['sessionId']?.toString();
      final participantId = decoded['participantId']?.toString();

      if (sessionId == null || participantId == null ||
          sessionId.isEmpty || participantId.isEmpty) return;
      if (sessionId != _session.id) return;
      if (_session.participantIds.contains(participantId)) return;

      setState(() {
        _session = _session.copyWith(
          participantIds: [..._session.participantIds, participantId],
        );
      });

      if (!mounted) return;
      final msg = AppLocalizations.of(context)!.lobbyNewParticipant;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    } catch (_) {}
  }

  Future<void> _handleVoteMessage(Map decoded) async {
    final sessionId = decoded['sessionId']?.toString();
    final rawVote = decoded['vote'];
    if (sessionId != _session.id || rawVote is! Map) return;

    try {
      final vote = Vote.fromJson(Map<String, dynamic>.from(rawVote));
      final repository = VotingRepositoryImpl();
      await repository.castVote(sessionId: sessionId!, vote: vote);

      // Reenvia o voto para que todos os dispositivos mantenham a mesma
      // VotingSession local. O emissor trata a mensagem como idempotente.
      await _peripheralService.sendMessage({
        'type': 'vote_cast',
        'sessionId': sessionId,
        'vote': vote.toJson(),
      });
    } catch (_) {
      // Ignora votos inválidos ou recebidos antes da sessão ser inicializada.
    }
  }

  Future<void> _sendExistingVotes(String? sessionId) async {
    if (sessionId != _session.id) return;

    try {
      final votingSession =
          await VotingRepositoryImpl().loadVotingSession(_session.id);
      if (votingSession == null) return;

      for (final vote in votingSession.votes) {
        await _peripheralService.sendMessage({
          'type': 'vote_cast',
          'sessionId': _session.id,
          'vote': vote.toJson(),
        });
      }
    } catch (_) {
      // O participante continuará a receber os votos novos normalmente.
    }
  }

  Future<void> _startBluetoothAdvertising() async {
    try {
      final result = await _peripheralService.startAdvertising();
      if (!mounted) return;
      setState(() {
        _advertising = result == 'granted' || result == 'ready';
      });
    } catch (_) {
      if (mounted) setState(() => _advertising = false);
    }
  }

  Future<void> _stopBluetoothAdvertising() async {
    try {
      await _peripheralService.stopAdvertising();
    } catch (_) {}
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _pulseController.dispose();
    _stopBluetoothAdvertising();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final qrData = jsonEncode({
      'type': 'session_invite',
      'sessionId': _session.id,
      'name': _session.name,
      'createdAt': _session.createdAt.toIso8601String(),
      'organizerId': _session.organizerId,
      'participantIds': _session.participantIds,
    });
    final participantCount = _session.participantIds.length + 1;

    return Scaffold(
      backgroundColor: MNColors.background,
      body: ParticleBackground(
        particleCount: 30,
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // ── AppBar ─────────────────────────────────────────────────
              SliverAppBar(
                backgroundColor: Colors.transparent,
                pinned: false,
                title: Text(
                  l10n.lobbyTitle,
                  style: const TextStyle(
                    color: MNColors.onBackground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded,
                      color: MNColors.onBackground),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── Nome da sessão ──────────────────────────────────
                    ShaderMask(
                      shaderCallback: (b) => const LinearGradient(
                        colors: [MNColors.primaryLight, MNColors.secondary],
                      ).createShader(b),
                      child: Text(
                        _session.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.lobbySubtitle,
                      style: const TextStyle(
                        color: MNColors.onSurfaceVar,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Status Bluetooth ────────────────────────────────
                    _BluetoothStatusCard(
                      advertising: _advertising,
                      pulseController: _pulseController,
                      label: _advertising
                          ? l10n.lobbyBluetoothAvailable
                          : l10n.lobbyBluetoothError,
                    ),

                    const SizedBox(height: 28),

                    // ── QR Code ─────────────────────────────────────────
                    _QrCodeCard(
                      qrData: qrData,
                      sessionId: _session.id,
                      sessionCodeLabel: l10n.lobbySessionCode,
                    ),

                    const SizedBox(height: 28),

                    // ── Participantes ───────────────────────────────────
                    _ParticipantsCard(
                      session: _session,
                      participantCount: participantCount,
                      l10n: l10n,
                    ),

                    const SizedBox(height: 28),

                    // ── Botão iniciar ───────────────────────────────────
                    _GradientButton(
                      icon: Icons.play_arrow_rounded,
                      label: l10n.lobbyStartVoting,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MovieFiltersPage(sessionId: _session.id),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bluetooth status card
// ─────────────────────────────────────────────────────────────────────────────

class _BluetoothStatusCard extends StatelessWidget {
  final bool advertising;
  final AnimationController pulseController;
  final String label;

  const _BluetoothStatusCard({
    required this.advertising,
    required this.pulseController,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor =
        advertising ? MNColors.secondary : const Color(0xFFF59E0B);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MNColors.surfaceVar,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: activeColor.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: pulseController,
            builder: (_, __) {
              final scale = advertising
                  ? 1.0 + pulseController.value * 0.25
                  : 1.0;
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: activeColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    advertising
                        ? Icons.bluetooth_searching_rounded
                        : Icons.bluetooth_disabled_rounded,
                    color: activeColor,
                    size: 20,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: activeColor,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// QR Code card
// ─────────────────────────────────────────────────────────────────────────────

class _QrCodeCard extends StatelessWidget {
  final String qrData;
  final String sessionId;
  final String sessionCodeLabel;

  const _QrCodeCard({
    required this.qrData,
    required this.sessionId,
    required this.sessionCodeLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: MNColors.surfaceVar,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MNColors.outlineVar),
        boxShadow: [
          BoxShadow(
            color: MNColors.primary.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // QR com fundo branco
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 200,
              backgroundColor: Colors.white,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            sessionCodeLabel,
            style: const TextStyle(
              color: MNColors.onSurfaceVar,
              fontSize: 12,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          ShaderMask(
            shaderCallback: (b) => const LinearGradient(
              colors: [MNColors.primaryLight, MNColors.secondary],
            ).createShader(b),
            child: Text(
              sessionId,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Participantes card
// ─────────────────────────────────────────────────────────────────────────────

class _ParticipantsCard extends StatelessWidget {
  final Session session;
  final int participantCount;
  final AppLocalizations l10n;

  const _ParticipantsCard({
    required this.session,
    required this.participantCount,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MNColors.surfaceVar,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MNColors.outlineVar),
      ),
      child: Column(
        children: [
          // Cabeçalho
          Row(
            children: [
              const Icon(Icons.people_rounded,
                  color: MNColors.primaryLight, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.lobbyParticipants,
                  style: const TextStyle(
                    color: MNColors.onBackground,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [MNColors.primary, MNColors.secondary],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$participantCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: MNColors.outlineVar, height: 1),
          const SizedBox(height: 16),

          // Organizador
          _ParticipantTile(
            icon: Icons.star_rounded,
            iconColor: const Color(0xFFFBBF24),
            name: l10n.lobbyYou,
            subtitle: l10n.lobbyOrganizer,
          ),

          if (session.participantIds.isEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const SizedBox(width: 8),
                const Icon(Icons.hourglass_empty_rounded,
                    size: 14, color: MNColors.onSurfaceVar),
                const SizedBox(width: 8),
                Text(
                  l10n.lobbyWaiting,
                  style: const TextStyle(
                    color: MNColors.onSurfaceVar,
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],

          for (final pid in session.participantIds) ...[
            const SizedBox(height: 8),
            _ParticipantTile(
              icon: Icons.person_rounded,
              iconColor: MNColors.primaryLight,
              name: l10n.lobbyParticipant,
              subtitle: pid,
            ),
          ],
        ],
      ),
    );
  }
}

class _ParticipantTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String name;
  final String subtitle;

  const _ParticipantTile({
    required this.icon,
    required this.iconColor,
    required this.name,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: MNColors.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: MNColors.onSurfaceVar,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Botão gradiente reutilizável
// ─────────────────────────────────────────────────────────────────────────────

class _GradientButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _GradientButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [MNColors.primary, MNColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: MNColors.primary.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
