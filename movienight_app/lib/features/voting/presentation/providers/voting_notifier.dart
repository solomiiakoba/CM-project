import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'package:movienight_app/features/movies/domain/movie.dart';
import 'package:movienight_app/features/voting/data/voting_repository_impl.dart';
import 'package:movienight_app/features/voting/domain/entities/vote.dart';
import 'package:movienight_app/features/voting/domain/entities/voting_session.dart';
import 'package:movienight_app/features/voting/domain/repositories/voting_repository.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Gesto do acelerómetro
// ──────────────────────────────────────────────────────────────────────────────

enum TiltGesture { none, right, left }

// ──────────────────────────────────────────────────────────────────────────────
// Estado
// ──────────────────────────────────────────────────────────────────────────────

class VotingState {
  /// Filmes que vão ser votados nesta sessão.
  final List<Movie> movies;

  /// Índice do filme atual.
  final int currentIndex;

  /// Inclinação atual do dispositivo em X (metros/s²).
  /// Negativo = esquerda, positivo = direita.
  final double tiltX;

  /// Gesto detetado (para feedback visual).
  final TiltGesture gesture;

  /// true enquanto o cooldown após voto está ativo (evita double-vote).
  final bool isAnimating;

  /// Votos já registados nesta sessão.
  final VotingSession? votingSession;

  /// ID do participante local.
  final String participantId;

  const VotingState({
    required this.movies,
    this.currentIndex = 0,
    this.tiltX = 0.0,
    this.gesture = TiltGesture.none,
    this.isAnimating = false,
    this.votingSession,
    required this.participantId,
  });

  bool get isFinished => currentIndex >= movies.length;
  Movie? get currentMovie =>
      isFinished ? null : movies[currentIndex];

  int get progress => currentIndex;
  int get total => movies.length;

  VotingState copyWith({
    List<Movie>? movies,
    int? currentIndex,
    double? tiltX,
    TiltGesture? gesture,
    bool? isAnimating,
    VotingSession? votingSession,
    String? participantId,
  }) {
    return VotingState(
      movies: movies ?? this.movies,
      currentIndex: currentIndex ?? this.currentIndex,
      tiltX: tiltX ?? this.tiltX,
      gesture: gesture ?? this.gesture,
      isAnimating: isAnimating ?? this.isAnimating,
      votingSession: votingSession ?? this.votingSession,
      participantId: participantId ?? this.participantId,
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Notifier
// ──────────────────────────────────────────────────────────────────────────────

class VotingNotifier extends StateNotifier<VotingState> {
  final VotingRepository _repository;

  StreamSubscription<AccelerometerEvent>? _accelSub;

  // Limiar de inclinação para disparar um voto (m/s²).
  // O eixo X do acelerómetro: valores tipicamente entre -10 e +10.
  // ~4.5 corresponde a ~25° de inclinação lateral.
  static const double _tiltThreshold = 4.5;

  // Tempo de cooldown após cada voto (ms).
  static const int _cooldownMs = 800;

  // Janela de tempo que o gesto tem de se manter (ms) para confirmar.
  static const int _confirmWindowMs = 300;

  Timer? _confirmTimer;
  TiltGesture _pendingGesture = TiltGesture.none;

  VotingNotifier(this._repository, VotingState initialState)
      : super(initialState);

  // ── Inicialização ──────────────────────────────────────────────────────────

  /// Inicia a sessão de votação com a lista de filmes e o participante.
  Future<void> startSession({
    required String sessionId,
    required List<Movie> movies,
    required String participantId,
  }) async {
    // Tenta carregar sessão existente (caso o utilizador regresse)
    var session = await _repository.loadVotingSession(sessionId);

    if (session == null) {
      session = VotingSession(
        sessionId: sessionId,
        movieIds: movies.map((m) => m.id).toList(),
      );
      await _repository.saveVotingSession(session);
    }

    // Descobre a partir de que filme continuar
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

    _startAccelerometer();
  }

  // ── Acelerómetro ──────────────────────────────────────────────────────────

  void _startAccelerometer() {
    _accelSub?.cancel();
    _accelSub = accelerometerEventStream(
      samplingPeriod: SensorInterval.gameInterval,
    ).listen(_onAccelerometerEvent);
  }

  void _onAccelerometerEvent(AccelerometerEvent event) {
    if (state.isAnimating || state.isFinished) return;

    final x = event.x;
    state = state.copyWith(tiltX: x);

    TiltGesture detected;
    if (x > _tiltThreshold) {
      // Inclinado para a esquerda física → eixo X positivo → dislike
      detected = TiltGesture.left;
    } else if (x < -_tiltThreshold) {
      // Inclinado para a direita física → eixo X negativo → like
      detected = TiltGesture.right;
    } else {
      detected = TiltGesture.none;
    }

    if (detected != state.gesture) {
      state = state.copyWith(gesture: detected);
    }

    // Lógica de confirmação: o gesto tem de se manter durante _confirmWindowMs
    if (detected != TiltGesture.none && detected != _pendingGesture) {
      _pendingGesture = detected;
      _confirmTimer?.cancel();
      _confirmTimer = Timer(
        const Duration(milliseconds: _confirmWindowMs),
        () {
          // Confirmar só se o gesto ainda estiver ativo
          if (state.gesture == _pendingGesture &&
              !state.isAnimating &&
              !state.isFinished) {
            _registerVote(_pendingGesture == TiltGesture.right);
          }
        },
      );
    } else if (detected == TiltGesture.none) {
      _pendingGesture = TiltGesture.none;
      _confirmTimer?.cancel();
    }
  }

  // ── Votação ───────────────────────────────────────────────────────────────

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
      final updated = await _repository.castVote(
        sessionId: state.votingSession!.sessionId,
        vote: vote,
      );

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

  /// Permite votar por toque (fallback caso o acelerómetro não funcione).
  Future<void> voteByTap(bool liked) async {
    if (state.isAnimating || state.isFinished) return;
    await _registerVote(liked);
  }

  // ── Cleanup ───────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _accelSub?.cancel();
    _confirmTimer?.cancel();
    super.dispose();
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Providers
// ──────────────────────────────────────────────────────────────────────────────

final votingRepositoryProvider = Provider<VotingRepository>((ref) {
  return VotingRepositoryImpl();
});

/// Provider criado com .family para receber os parâmetros de sessão.
/// Uso: ref.watch(votingProvider(VotingParams(...)))
final votingProvider = StateNotifierProvider.family<
    VotingNotifier, VotingState, VotingParams>((ref, params) {
  final repo = ref.watch(votingRepositoryProvider);
  final notifier = VotingNotifier(
    repo,
    VotingState(
      movies: params.movies,
      participantId: params.participantId,
    ),
  );
  // Arranca a sessão assim que o provider é criado
  notifier.startSession(
    sessionId: params.sessionId,
    movies: params.movies,
    participantId: params.participantId,
  );
  return notifier;
});

/// Parâmetros passados ao provider via .family.
class VotingParams {
  final String sessionId;
  final List<Movie> movies;
  final String participantId;

  const VotingParams({
    required this.sessionId,
    required this.movies,
    required this.participantId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VotingParams && other.sessionId == sessionId;

  @override
  int get hashCode => sessionId.hashCode;
}
