/// Entidade de domínio que representa a configuração visual e estatística do Troféu AR.
class ArTrophyConfig {
  final String movieId;
  final String movieTitle;
  final String? posterPath;
  final double voteAverage;
  final int affirmativeVotes;
  final int totalParticipants;
  final String celebrationMessage;

  const ArTrophyConfig({
    required this.movieId,
    required this.movieTitle,
    this.posterPath,
    this.voteAverage = 0.0,
    this.affirmativeVotes = 0,
    this.totalParticipants = 0,
    this.celebrationMessage = 'Filme Escolhido!',
  });

  /// Percentagem de aprovação no grupo.
  double get winPercentage {
    if (totalParticipants <= 0) return 0.0;
    return (affirmativeVotes / totalParticipants) * 100.0;
  }

  /// Classificação TMDb formatada (ex: "8.4").
  String get formattedRating => voteAverage.toStringAsFixed(1);

  ArTrophyConfig copyWith({
    String? movieId,
    String? movieTitle,
    String? posterPath,
    double? voteAverage,
    int? affirmativeVotes,
    int? totalParticipants,
    String? celebrationMessage,
  }) {
    return ArTrophyConfig(
      movieId: movieId ?? this.movieId,
      movieTitle: movieTitle ?? this.movieTitle,
      posterPath: posterPath ?? this.posterPath,
      voteAverage: voteAverage ?? this.voteAverage,
      affirmativeVotes: affirmativeVotes ?? this.affirmativeVotes,
      totalParticipants: totalParticipants ?? this.totalParticipants,
      celebrationMessage: celebrationMessage ?? this.celebrationMessage,
    );
  }
}
