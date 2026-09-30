/// Representa o voto de um participante num filme.
class Vote {
  final String movieId;
  final String participantId;
  final bool liked;
  final DateTime votedAt;

  const Vote({
    required this.movieId,
    required this.participantId,
    required this.liked,
    required this.votedAt,
  });

  Map<String, dynamic> toJson() => {
        'movieId': movieId,
        'participantId': participantId,
        'liked': liked,
        'votedAt': votedAt.toIso8601String(),
      };

  factory Vote.fromJson(Map<String, dynamic> json) => Vote(
        movieId: json['movieId'] as String,
        participantId: json['participantId'] as String,
        liked: json['liked'] as bool,
        votedAt: DateTime.parse(json['votedAt'] as String),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vote &&
          other.movieId == movieId &&
          other.participantId == participantId;

  @override
  int get hashCode => Object.hash(movieId, participantId);
}
