import '../../../../core/config/tmdb_config.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_filters.dart';
import '../datasources/tmdb_genre_catalog.dart';

/// Data Transfer Object (DTO) for movie items returned by the TMDb API.
class TmdbMovieDto {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String releaseDate;
  final double voteAverage;
  final List<int> genreIds;

  const TmdbMovieDto({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.genreIds,
  });

  factory TmdbMovieDto.fromJson(Map<String, dynamic> json) {
    return TmdbMovieDto(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      releaseDate: json['release_date'] as String? ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      genreIds: (json['genre_ids'] as List?)?.cast<int>() ?? const [],
    );
  }

  /// Converts this TMDb DTO into the clean domain [Movie] entity.
  Movie toDomain({
    required MovieFilters filters,
    String languageCode = 'pt',
  }) {
    final posterUrl = (posterPath != null && posterPath!.isNotEmpty)
        ? '${TmdbConfig.imageBaseUrl}$posterPath'
        : null;

    int releaseYear = DateTime.now().year;
    if (releaseDate.isNotEmpty && releaseDate.contains('-')) {
      releaseYear = int.tryParse(releaseDate.split('-')[0]) ?? releaseYear;
    }

    final genreNames = genreIds
        .map((id) => TmdbGenreCatalog.genreIdToEntity[id]?.localized(languageCode))
        .whereType<String>()
        .toList();

    final fallbackTitle = languageCode == 'en' ? 'Untitled' : 'Sem título';
    final fallbackOverview = languageCode == 'en'
        ? 'No overview available.'
        : 'Sinopse não disponível.';

    return Movie(
      id: id.toString(),
      title: title.trim().isEmpty ? fallbackTitle : title,
      overview: overview.trim().isEmpty ? fallbackOverview : overview,
      posterPath: posterUrl,
      releaseYear: releaseYear,
      genres: genreNames.isNotEmpty ? genreNames : filters.genres,
      rating: voteAverage,
      durationMinutes: null,
      streamingPlatforms: filters.streamingPlatforms,
    );
  }
}
