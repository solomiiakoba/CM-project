import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movienight_app/core/bluetooth/movie_night_peripheral_service.dart';
import 'package:movienight_app/features/session/domain/entities/session.dart';
import 'package:movienight_app/features/session/domain/repositories/session_repository.dart';
import 'package:movienight_app/features/session/presentation/providers/session_controller.dart';
import 'package:movienight_app/features/voting/domain/entities/vote.dart';
import 'package:movienight_app/features/voting/domain/repositories/voting_repository.dart';
import 'package:movienight_app/features/voting/presentation/providers/voting_providers.dart';

/// Estado do lobby da sessão com membros conetados e estado de difusão BLE.
class SessionLobbyState {
  final Session session;
  final bool isAdvertising;
  final String? lastJoinedParticipantId;

  const SessionLobbyState({
    required this.session,
    this.isAdvertising = false,
    this.lastJoinedParticipantId,
  });

  SessionLobbyState copyWith({
    Session? session,
    bool? isAdvertising,
    String? lastJoinedParticipantId,
  }) {
    return SessionLobbyState(
      session: session ?? this.session,
      isAdvertising: isAdvertising ?? this.isAdvertising,
      lastJoinedParticipantId: lastJoinedParticipantId,
    );
  }
}

/// Notifier que orquestra a comunicação Bluetooth GATT e a entrada de participantes no lobby.
class SessionLobbyNotifier extends StateNotifier<SessionLobbyState> {
  final MovieNightPeripheralService _peripheralService;
  final SessionRepository repository;
  final VotingRepository votingRepository;
  StreamSubscription<Uint8List>? _messageSubscription;

  SessionLobbyNotifier({
    required Session initialSession,
    required this.repository,
    required this.votingRepository,
    MovieNightPeripheralService? peripheralService,
  })  : _peripheralService = peripheralService ?? MovieNightPeripheralService(),
        super(SessionLobbyState(session: initialSession)) {
    _init();
  }

  void _init() {
    _listenForBluetoothMessages();
    startAdvertising();
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
          sessionId.isEmpty || participantId.isEmpty) {
        return;
      }
      if (sessionId != state.session.id) return;
      if (state.session.participantIds.contains(participantId)) return;

      final updatedSession = state.session.copyWith(
        participantIds: [...state.session.participantIds, participantId],
      );

      repository.saveSession(updatedSession);

      state = state.copyWith(
        session: updatedSession,
        lastJoinedParticipantId: participantId,
      );
    } catch (_) {}
  }

  Future<void> _handleVoteMessage(Map decoded) async {
    final sessionId = decoded['sessionId']?.toString();
    final rawVote = decoded['vote'];
    if (sessionId != state.session.id || rawVote is! Map) return;

    try {
      final vote = Vote.fromJson(Map<String, dynamic>.from(rawVote));
      await votingRepository.castVote(sessionId: sessionId!, vote: vote);

      await _peripheralService.sendMessage({
        'type': 'vote_cast',
        'sessionId': sessionId,
        'vote': vote.toJson(),
      });
    } catch (_) {}
  }

  Future<void> _sendExistingVotes(String? sessionId) async {
    if (sessionId != state.session.id) return;

    try {
      final votingSession =
          await votingRepository.loadVotingSession(state.session.id);
      if (votingSession == null) return;

      for (final vote in votingSession.votes) {
        await _peripheralService.sendMessage({
          'type': 'vote_cast',
          'sessionId': state.session.id,
          'vote': vote.toJson(),
        });
      }
    } catch (_) {}
  }

  Future<void> startAdvertising() async {
    try {
      final result = await _peripheralService.startAdvertising();
      final isReady = result == 'granted' || result == 'ready';
      state = state.copyWith(isAdvertising: isReady);
    } catch (_) {
      state = state.copyWith(isAdvertising: false);
    }
  }

  Future<void> stopAdvertising() async {
    try {
      await _peripheralService.stopAdvertising();
    } catch (_) {}
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    stopAdvertising();
    super.dispose();
  }
}

final sessionLobbyProvider = StateNotifierProvider.autoDispose
    .family<SessionLobbyNotifier, SessionLobbyState, Session>((ref, initialSession) {
  final sessionRepo = ref.watch(sessionRepositoryProvider);
  final votingRepo = ref.watch(votingRepositoryProvider);
  return SessionLobbyNotifier(
    initialSession: initialSession,
    repository: sessionRepo,
    votingRepository: votingRepo,
  );
});
