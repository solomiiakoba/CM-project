/// Filtros que o organizador configura antes de carregar os filmes para a sessão.
class MovieFilters {
  /// Géneros selecionados. Lista vazia = todos os géneros.
  final List<String> genres;

  /// Ano mínimo de lançamento (inclusive).
  final int? minYear;

  /// Ano máximo de lançamento (inclusive).
  final int? maxYear;

  /// Duração máxima em minutos. null = sem limite.
  final int? maxDurationMinutes;

  /// Plataformas de streaming selecionadas. Lista vazia = todas.
  final List<String> streamingPlatforms;

  /// Rating mínimo (0.0–10.0).
  final double minRating;

  /// Número máximo de filmes a sugerir.
  final int maxResults;

  const MovieFilters({
    this.genres = const [],
    this.minYear,
    this.maxYear,
    this.maxDurationMinutes,
    this.streamingPlatforms = const [],
    this.minRating = 0.0,
    this.maxResults = 20,
  });

  /// Filtros sem restrições (mostra tudo).
  static const empty = MovieFilters();

  MovieFilters copyWith({
    List<String>? genres,
    int? minYear,
    int? maxYear,
    int? maxDurationMinutes,
    List<String>? streamingPlatforms,
    double? minRating,
    int? maxResults,
  }) {
    return MovieFilters(
      genres: genres ?? this.genres,
      minYear: minYear ?? this.minYear,
      maxYear: maxYear ?? this.maxYear,
      maxDurationMinutes: maxDurationMinutes ?? this.maxDurationMinutes,
      streamingPlatforms: streamingPlatforms ?? this.streamingPlatforms,
      minRating: minRating ?? this.minRating,
      maxResults: maxResults ?? this.maxResults,
    );
  }

  /// Remove um filtro específico (seta para null/vazio).
  MovieFilters clearMinYear() => MovieFilters(
        genres: genres,
        maxYear: maxYear,
        maxDurationMinutes: maxDurationMinutes,
        streamingPlatforms: streamingPlatforms,
        minRating: minRating,
        maxResults: maxResults,
      );

  MovieFilters clearMaxYear() => MovieFilters(
        genres: genres,
        minYear: minYear,
        maxDurationMinutes: maxDurationMinutes,
        streamingPlatforms: streamingPlatforms,
        minRating: minRating,
        maxResults: maxResults,
      );

  MovieFilters clearMaxDuration() => MovieFilters(
        genres: genres,
        minYear: minYear,
        maxYear: maxYear,
        streamingPlatforms: streamingPlatforms,
        minRating: minRating,
        maxResults: maxResults,
      );

  bool get hasActiveFilters =>
      genres.isNotEmpty ||
      minYear != null ||
      maxYear != null ||
      maxDurationMinutes != null ||
      streamingPlatforms.isNotEmpty ||
      minRating > 0.0;

  Map<String, dynamic> toJson() {
    return {
      'genres': genres,
      'minYear': minYear,
      'maxYear': maxYear,
      'maxDurationMinutes': maxDurationMinutes,
      'streamingPlatforms': streamingPlatforms,
      'minRating': minRating,
      'maxResults': maxResults,
    };
  }

  factory MovieFilters.fromJson(Map<String, dynamic> json) {
    return MovieFilters(
      genres: List<String>.from(json['genres'] as List? ?? []),
      minYear: json['minYear'] as int?,
      maxYear: json['maxYear'] as int?,
      maxDurationMinutes: json['maxDurationMinutes'] as int?,
      streamingPlatforms: List<String>.from(
        json['streamingPlatforms'] as List? ?? [],
      ),
      minRating: (json['minRating'] as num?)?.toDouble() ?? 0.0,
      maxResults: (json['maxResults'] as int?) ?? 20,
    );
  }
}
