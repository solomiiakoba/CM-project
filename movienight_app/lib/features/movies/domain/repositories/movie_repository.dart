import 'package:movienight_app/features/movies/domain/movie.dart';
import 'package:movienight_app/features/movies/domain/movie_filters.dart';

/// Contrato do repositório de filmes.
/// A implementação pode ser mock, TMDB, OMDb, etc.
abstract class MovieRepository {
  /// Busca filmes com base nos filtros fornecidos.
  /// Pode vir da API remota ou de dados locais/mock.
  Future<List<Movie>> fetchMovies(MovieFilters filters);

  /// Guarda os filmes de uma sessão localmente para acesso offline.
  Future<void> cacheMoviesForSession(String sessionId, List<Movie> movies);

  /// Recupera os filmes em cache para uma sessão.
  /// Retorna lista vazia se não houver cache.
  Future<List<Movie>> getCachedMovies(String sessionId);

  /// Apaga os filmes em cache de uma sessão.
  Future<void> clearCachedMovies(String sessionId);

  /// Retorna todos os géneros disponíveis.
  Future<List<String>> getAvailableGenres();

  /// Retorna todas as plataformas de streaming disponíveis.
  Future<List<String>> getAvailableStreamingPlatforms();
}
