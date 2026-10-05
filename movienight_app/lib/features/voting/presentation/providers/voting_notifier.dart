import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/bluetooth/movie_night_ble_client.dart';
import '../../../../core/bluetooth/movie_night_peripheral_service.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../domain/entities/vote.dart';
import '../../domain/entities/voting_session.dart';
import '../../domain/usecases/cast_vote_usecase.dart';
import '../../domain/usecases/get_voting_session_usecase.dart';
import '../../domain/usecases/save_voting_session_usecase.dart';
import '../services/tilt_sensor_service.dart';
import 'voting_state.dart';

export 'voting_params.dart';
export 'voting_state.dart';

class VotingNotifier extends StateNotifier<VotingState> {
  final SaveVotingSessionUseCase saveVotingSession;
  final GetVotingSessionUseCase getVotingSession;
  final CastVoteUseCase castVote;
  final MovieNightBleClient? bleClient;
  final MovieNightPeripheralService? peripheralService;

  late final TiltSensorService _sensorService;
  StreamSubscription<Map<String, dynamic>>? _bleSub;

  static const int _cooldownMs = 800;

  VotingNotifier({
    required this.saveVotingSession,
    required this.getVotingSession,
    required this.castVote,
    required VotingState initialState,
    this.bleClient,
    this.peripheralService,
  })  : super(initialState) {
    _sensorService = TiltSensorService(
      canProcessGesture: () => !state.isAnimating && !state.isFinished,
      onTiltChanged: (tiltX, gesture) {
        if (state.tiltX != tiltX || state.gesture != gesture) {
          state = state.copyWith(tiltX: tiltX, gesture: gesture);
        }
      },
      onGestureConfirmed: (gesture) {
        if (!state.isAnimating && !state.isFinished) {
          _registerVote(gesture == TiltGesture.right);
        }
      },
    );
  }

  Future<void> startSession({
    required String sessionId,
    required List<Movie> movies,
    required String participantId,
  }) async {
    var session = await getVotingSession(sessionId);

    if (session == null) {
      session = VotingSession(
        sessionId: sessionId,
        movieIds: movies.map((m) => m.id).toList(),
      );
      await saveVotingSession(session);
    }

    final votedIds = session.votes
        .where((v) => v.participantId == participantId)
        .map((v) => v.movieId)
        .toSet();

    final resumeIndex = movies.indexWhere((m) => !votedIds.contains(m.id));
    final startIndex = resumeIndex == -1 ? movies.length : resumeIndex;

    state = state.copyWith(
      movies: movies,
      currentIndex: startIndex,
      votingSession: session,
      participantId: participantId,
    );

    _sensorService.start();
    _listenForRemoteVotes();

    try {
      await bleClient?.sendMessage({
        'type': 'request_votes',
        'sessionId': sessionId,
      });
    } catch (_) {}
  }

  void _listenForRemoteVotes() {
    _bleSub?.cancel();
    _bleSub = bleClient?.messages.listen(_handleRemoteMessage);
  }

  Future<void> _handleRemoteMessage(Map<String, dynamic> message) async {
    if (message['type'] != 'vote_cast') return;
    if (message['sessionId']?.toString() != state.votingSession?.sessionId) return;

    final rawVote = message['vote'];
    if (rawVote is! Map) return;

    try {
      final vote = Vote.fromJson(Map<String, dynamic>.from(rawVote));
      final updated = await castVote(
        sessionId: state.votingSession!.sessionId,
        vote: vote,
      );
      if (!mounted) return;
      state = state.copyWith(votingSession: updated);
    } catch (_) {}
  }

  Future<void> _registerVote(bool liked) async {
    final movie = state.currentMovie;
    if (movie == null || state.votingSession == null) return;

    state = state.copyWith(isAnimating: true);

    final vote = Vote(
      movieId: movie.id,
      participantId: state.participantId,
      liked: liked,
      votedAt: DateTime.now(),
    );

    try {
      final updated = await castVote(
        sessionId: state.votingSession!.sessionId,
        vote: vote,
      );

      try {
        await bleClient?.sendMessage({
          'type': 'vote_cast',
          'sessionId': state.votingSession!.sessionId,
          'vote': vote.toJson(),
        });
      } catch (_) {}

      try {
        await peripheralService?.sendMessage({
          'type': 'vote_cast',
          'sessionId': state.votingSession!.sessionId,
          'vote': vote.toJson(),
        });
      } catch (_) {}

      await Future.delayed(const Duration(milliseconds: _cooldownMs));

      state = state.copyWith(
        votingSession: updated,
        currentIndex: state.currentIndex + 1,
        tiltX: 0.0,
        gesture: TiltGesture.none,
        isAnimating: false,
      );
    } catch (e) {
      state = state.copyWith(isAnimating: false);
    }
  }

  Future<void> voteByTap(bool liked) async {
    if (state.isAnimating || state.isFinished) return;
    await _registerVote(liked);
  }

  @override
  void dispose() {
    _sensorService.dispose();
    _bleSub?.cancel();
    super.dispose();
  }
}
