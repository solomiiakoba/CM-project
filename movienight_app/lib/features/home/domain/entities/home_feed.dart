import '../../../movies/domain/entities/movie.dart';

/// Entidade de domínio que agrupa os dados do feed principal da Home Screen.
class HomeFeed {
  final Movie? spotlightMovie;
  final List<Movie> trendingMovies;

  const HomeFeed({
    this.spotlightMovie,
    this.trendingMovies = const [],
  });

  bool get hasSpotlight => spotlightMovie != null;
  bool get hasTrending => trendingMovies.isNotEmpty;
  bool get isEmpty => spotlightMovie == null && trendingMovies.isEmpty;
}
