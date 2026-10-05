import '../../../movies/domain/entities/movie.dart';
import '../../domain/entities/voting_session.dart';

enum TiltGesture { none, right, left }

class VotingState {
  final List<Movie> movies;
  final int currentIndex;
  final double tiltX;
  final TiltGesture gesture;
  final bool isAnimating;
  final VotingSession? votingSession;
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
  Movie? get currentMovie => isFinished ? null : movies[currentIndex];

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
