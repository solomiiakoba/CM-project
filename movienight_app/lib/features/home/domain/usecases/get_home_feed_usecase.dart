import '../../../movies/domain/entities/movie_filters.dart';
import '../../../movies/domain/repositories/movie_repository.dart';
import '../entities/home_feed.dart';

/// Caso de uso que obtém o feed de filmes da Home com spotlight e tendências.
class GetHomeFeedUseCase {
  final MovieRepository _movieRepository;

  const GetHomeFeedUseCase(this._movieRepository);

  Future<HomeFeed> execute({String languageCode = 'pt'}) async {
    try {
      final movies = await _movieRepository.fetchMovies(
        const MovieFilters(maxResults: 15),
        languageCode: languageCode,
      );

      if (movies.isEmpty) {
        return const HomeFeed();
      }

      final spotlight = movies.firstWhere(
        (m) => m.posterPath != null && m.posterPath!.isNotEmpty,
        orElse: () => movies.first,
      );

      final trending = movies.where((m) => m.id != spotlight.id).toList();

      return HomeFeed(
        spotlightMovie: spotlight,
        trendingMovies: trending,
      );
    } catch (_) {
      return const HomeFeed();
    }
  }
}
