import 'package:movienight_app/features/movies/domain/entities/movie.dart';
import 'package:movienight_app/features/movies/domain/entities/movie_filters.dart';

/// Contrato do repositório de filmes.
/// A implementação pode ser mock, TMDB, OMDb, etc.
abstract class MovieRepository {
  /// Busca filmes com base nos filtros fornecidos.
  /// Pode vir da API remota ou de dados locais/mock.
  Future<List<Movie>> fetchMovies(MovieFilters filters, {String languageCode = 'pt'});

  /// Guarda os filmes de uma sessão localmente para acesso offline.
  Future<void> cacheMoviesForSession(String sessionId, List<Movie> movies);

  /// Recupera os filmes em cache para uma sessão.
  /// Retorna lista vazia se não houver cache.
  Future<List<Movie>> getCachedMovies(String sessionId);

  /// Apaga os filmes em cache de uma sessão.
  Future<void> clearCachedMovies(String sessionId);

  /// Retorna todos os géneros disponíveis com suporte a idioma.
  Future<List<String>> getAvailableGenres({String languageCode = 'pt'});

  /// Retorna todas as plataformas de streaming disponíveis.
  Future<List<String>> getAvailableStreamingPlatforms();

  /// Retorna as plataformas de streaming em Portugal onde um filme específico está disponível.
  Future<List<String>> getMovieStreamingProviders(String movieId);
}
