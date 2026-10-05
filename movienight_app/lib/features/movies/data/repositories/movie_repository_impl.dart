import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_filters.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/mock_movie_datasource.dart';
import '../datasources/movie_local_datasource.dart';
import '../datasources/tmdb_api_client.dart';

/// Clean Architecture implementation of [MovieRepository].
/// Coordinates remote TMDb fetching, local caching, and offline fallbacks.
class MovieRepositoryImpl implements MovieRepository {
  final TmdbApiClient _tmdbApiClient;
  final MockMovieDataSource _mockDataSource;
  final MovieLocalDataSource _localDataSource;

  MovieRepositoryImpl({
    TmdbApiClient? tmdbApiClient,
    MockMovieDataSource? mockDataSource,
    MovieLocalDataSource? localDataSource,
  })  : _tmdbApiClient = tmdbApiClient ?? TmdbApiClient(),
        _mockDataSource = mockDataSource ?? MockMovieDataSource(),
        _localDataSource = localDataSource ?? MovieLocalDataSource();

  @override
  Future<List<Movie>> fetchMovies(
    MovieFilters filters, {
    String languageCode = 'pt',
  }) async {
    try {
      // 1. Tenta obter filmes reais através da API do TMDb com o idioma selecionado
      final dtos = await _tmdbApiClient.discoverMovies(
        filters,
        languageCode: languageCode,
      );

      final remoteMovies = dtos
          .map((dto) => dto.toDomain(filters: filters, languageCode: languageCode))
          .toList();

      if (remoteMovies.isNotEmpty) {
        // Guarda no catálogo persistente para consultas futuras offline
        await _localDataSource.saveLastGlobalCatalog(remoteMovies);
        return remoteMovies;
      }
    } catch (_) {
      // Falha de rede, chave não configurada, timeout: passa para cache offline
    }

    // 2. Se offline, tenta usar filmes TMDb previamente guardados em cache
    try {
      final cachedGlobal = await _localDataSource.loadLastGlobalCatalog();
      if (cachedGlobal.isNotEmpty) {
        final filtered = cachedGlobal.where((m) {
          if (filters.minRating > 0 && m.rating < filters.minRating) return false;
          if (filters.minYear != null && m.releaseYear < filters.minYear!) return false;
          if (filters.maxYear != null && m.releaseYear > filters.maxYear!) return false;
          return true;
        }).take(filters.maxResults).toList();

        if (filtered.isNotEmpty) return filtered;
      }
    } catch (_) {}

    // 3. Fallback final resiliente: dataset embutido para garantir que a sessão nunca quebra
    return _mockDataSource.getFilteredMovies(filters);
  }

  @override
  Future<void> cacheMoviesForSession(
    String sessionId,
    List<Movie> movies,
  ) async {
    await _localDataSource.saveMovies(sessionId, movies);
  }

  @override
  Future<List<Movie>> getCachedMovies(String sessionId) async {
    return _localDataSource.loadMovies(sessionId);
  }

  @override
  Future<void> clearCachedMovies(String sessionId) async {
    await _localDataSource.clearMovies(sessionId);
  }

  @override
  Future<List<String>> getAvailableGenres({String languageCode = 'pt'}) async {
    return _tmdbApiClient.getAvailableGenres(languageCode: languageCode);
  }

  @override
  Future<List<String>> getAvailableStreamingPlatforms() async {
    return _tmdbApiClient.getAvailableStreamingPlatforms();
  }

  @override
  Future<List<String>> getMovieStreamingProviders(String movieId) async {
    try {
      final providers = await _tmdbApiClient.fetchMovieWatchProviders(movieId);
      if (providers.isNotEmpty) return providers;
    } catch (_) {}

    return [];
  }
}
