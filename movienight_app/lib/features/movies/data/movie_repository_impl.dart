import 'package:movienight_app/features/movies/domain/movie.dart';
import 'package:movienight_app/features/movies/domain/movie_filters.dart';
import 'package:movienight_app/features/movies/domain/repositories/movie_repository.dart';
import 'package:movienight_app/features/movies/data/datasources/mock_movie_datasource.dart';
import 'package:movienight_app/features/movies/data/datasources/movie_local_datasource.dart';

/// Implementação do repositório de filmes com dados mock e cache local.
/// Para usar a API real, basta criar uma nova implementação de [MovieRepository]
/// e injetar via Riverpod em vez desta.
class MovieRepositoryImpl implements MovieRepository {
  final MockMovieDataSource _mockDataSource;
  final MovieLocalDataSource _localDataSource;

  MovieRepositoryImpl({
    MockMovieDataSource? mockDataSource,
    MovieLocalDataSource? localDataSource,
  })  : _mockDataSource = mockDataSource ?? MockMovieDataSource(),
        _localDataSource = localDataSource ?? MovieLocalDataSource();

  @override
  Future<List<Movie>> fetchMovies(MovieFilters filters) async {
    // Simula uma pequena latência para parecer uma chamada de rede real
    await Future.delayed(const Duration(milliseconds: 400));
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
  Future<List<String>> getAvailableGenres() async {
    return _mockDataSource.getAvailableGenres();
  }

  @override
  Future<List<String>> getAvailableStreamingPlatforms() async {
    return _mockDataSource.getAvailableStreamingPlatforms();
  }
}
