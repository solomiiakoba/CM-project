import 'vote.dart';

/// Agrega todos os votos de uma sessão e calcula o ranking.
class VotingSession {
  final String sessionId;
  final List<String> movieIds; // ordem original dos filmes
  final List<Vote> votes;

  const VotingSession({
    required this.sessionId,
    required this.movieIds,
    this.votes = const [],
  });

  VotingSession copyWith({
    String? sessionId,
    List<String>? movieIds,
    List<Vote>? votes,
  }) {
    return VotingSession(
      sessionId: sessionId ?? this.sessionId,
      movieIds: movieIds ?? this.movieIds,
      votes: votes ?? this.votes,
    );
  }

  /// Adiciona ou substitui o voto de um participante num filme.
  VotingSession addVote(Vote vote) {
    final updated = votes.where(
      (v) => !(v.movieId == vote.movieId && v.participantId == vote.participantId),
    ).toList()
      ..add(vote);
    return copyWith(votes: updated);
  }

  /// Likes por filme. Retorna mapa movieId → count.
  Map<String, int> get likesByMovie {
    final counts = <String, int>{};
    for (final id in movieIds) {
      counts[id] = 0;
    }
    for (final vote in votes) {
      if (vote.liked) {
        counts[vote.movieId] = (counts[vote.movieId] ?? 0) + 1;
      }
    }
    return counts;
  }

  /// Lista de movieIds ordenada por likes (descendente).
  List<String> get rankedMovieIds {
    final likes = likesByMovie;
    final ids = List<String>.from(movieIds);
    ids.sort((a, b) => (likes[b] ?? 0).compareTo(likes[a] ?? 0));
    return ids;
  }

  /// Retorna true se o participante já votou em todos os filmes.
  bool hasParticipantFinished(String participantId) {
    final votedIds = votes
        .where((v) => v.participantId == participantId)
        .map((v) => v.movieId)
        .toSet();
    return movieIds.every((id) => votedIds.contains(id));
  }

  Map<String, dynamic> toJson() => {
        'sessionId': sessionId,
        'movieIds': movieIds,
        'votes': votes.map((v) => v.toJson()).toList(),
      };

  factory VotingSession.fromJson(Map<String, dynamic> json) => VotingSession(
        sessionId: json['sessionId'] as String,
        movieIds: List<String>.from(json['movieIds'] as List),
        votes: (json['votes'] as List)
            .map((v) => Vote.fromJson(v as Map<String, dynamic>))
            .toList(),
      );
}
