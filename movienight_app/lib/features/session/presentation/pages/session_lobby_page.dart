import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movienight_app/app/theme.dart';
import 'package:movienight_app/features/movies/presentation/pages/movie_filters_page.dart';
import 'package:movienight_app/features/session/domain/entities/session.dart';
import 'package:movienight_app/features/session/presentation/providers/session_lobby_notifier.dart';
import 'package:movienight_app/features/session/presentation/widgets/bluetooth_status_card.dart';
import 'package:movienight_app/features/session/presentation/widgets/participants_card.dart';
import 'package:movienight_app/features/session/presentation/widgets/qr_code_card.dart';
import 'package:movienight_app/l10n/app_localizations.dart';
import 'package:movienight_app/shared/widgets/glass_back_button.dart';
import 'package:movienight_app/shared/widgets/gradient_action_button.dart';
import 'package:movienight_app/shared/widgets/particle_background.dart';

/// Ecrã de lobby da sessão onde o anfitrião partilha o código QR e aguarda a entrada dos participantes.
class SessionLobbyPage extends ConsumerStatefulWidget {
  final Session session;

  const SessionLobbyPage({
    super.key,
    required this.session,
  });

  @override
  ConsumerState<SessionLobbyPage> createState() => _SessionLobbyPageState();
}

class _SessionLobbyPageState extends ConsumerState<SessionLobbyPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    final lobbyState = ref.watch(sessionLobbyProvider(widget.session));
    final currentSession = lobbyState.session;

    ref.listen<SessionLobbyState>(sessionLobbyProvider(widget.session), (prev, next) {
      if (next.lastJoinedParticipantId != null &&
          next.lastJoinedParticipantId != prev?.lastJoinedParticipantId) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.lobbyNewParticipant)),
        );
      }
    });

    final qrData = jsonEncode({
      'type': 'session_invite',
      'sessionId': currentSession.id,
      'name': currentSession.name,
      'createdAt': currentSession.createdAt.toIso8601String(),
      'organizerId': currentSession.organizerId,
      'participantIds': currentSession.participantIds,
    });
    final participantCount = currentSession.participantIds.length + 1;

    return Scaffold(
      backgroundColor: Colors.transparent,
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
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                leading: Center(
                  child: GlassBackButton(
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── Session name ────────────────────────────────────
                    ShaderMask(
                      shaderCallback: (b) => const LinearGradient(
                        colors: [MNColors.primaryLight, MNColors.secondary],
                      ).createShader(b),
                      child: Text(
                        currentSession.name,
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
                      style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
                    ),

                    const SizedBox(height: 24),

                    // ── Bluetooth status card ───────────────────────────
                    BluetoothStatusCard(
                      advertising: lobbyState.isAdvertising,
                      pulseController: _pulseController,
                      label: lobbyState.isAdvertising
                          ? l10n.lobbyBluetoothAvailable
                          : l10n.lobbyBluetoothError,
                    ),

                    const SizedBox(height: 28),

                    // ── QR Code card ────────────────────────────────────
                    QrCodeCard(
                      qrData: qrData,
                      sessionId: currentSession.id,
                      sessionCodeLabel: l10n.lobbySessionCode,
                    ),

                    const SizedBox(height: 28),

                    // ── Participants card ───────────────────────────────
                    ParticipantsCard(
                      session: currentSession,
                      participantCount: participantCount,
                    ),

                    const SizedBox(height: 28),

                    // ── Start button ────────────────────────────────────
                    GradientActionButton(
                      icon: Icons.play_arrow_rounded,
                      label: l10n.lobbyStartVoting,
                      padding: EdgeInsets.zero,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MovieFiltersPage(sessionId: currentSession.id),
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
