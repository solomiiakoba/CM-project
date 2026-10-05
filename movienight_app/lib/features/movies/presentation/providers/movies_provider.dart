import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/movie_repository_impl.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_filters.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../../../shared/providers/locale_provider.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Providers de infraestrutura
// ──────────────────────────────────────────────────────────────────────────────

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  return MovieRepositoryImpl() as MovieRepository;
});

// ──────────────────────────────────────────────────────────────────────────────
// Estado dos filmes carregados
// ──────────────────────────────────────────────────────────────────────────────

/// Estado do ecrã de filmes.
class MoviesState {
  final List<Movie> movies;
  final bool isLoading;
  final String? errorMessage;

  const MoviesState({
    this.movies = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  bool get hasMovies => movies.isNotEmpty;
  bool get hasError => errorMessage != null;

  MoviesState copyWith({
    List<Movie>? movies,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MoviesState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  MoviesState clearError() => MoviesState(
        movies: movies,
        isLoading: isLoading,
      );
}

// ──────────────────────────────────────────────────────────────────────────────
// Notifier
// ──────────────────────────────────────────────────────────────────────────────

class MoviesNotifier extends StateNotifier<MoviesState> {
  final MovieRepository _repository;

  MoviesNotifier(this._repository) : super(const MoviesState());

  /// Carrega os filmes com os filtros fornecidos e guarda cache para a sessão.
  Future<void> loadMovies({
    required MovieFilters filters,
    String? sessionId,
    String languageCode = 'pt',
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final movies = await _repository.fetchMovies(
        filters,
        languageCode: languageCode,
      );

      // Guarda em cache se tiver sessionId
      if (sessionId != null && movies.isNotEmpty) {
        await _repository.cacheMoviesForSession(sessionId, movies);
      }

      state = MoviesState(movies: movies);
    } catch (e) {
      state = MoviesState(errorMessage: e.toString());
    }
  }

  /// Carrega a partir do cache local (modo offline).
  Future<void> loadFromCache(String sessionId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final movies = await _repository.getCachedMovies(sessionId);
      state = MoviesState(movies: movies);
    } catch (e) {
      state = MoviesState(errorMessage: e.toString());
    }
  }

  /// Limpa a lista de filmes.
  void clear() {
    state = const MoviesState();
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Provider exposto
// ──────────────────────────────────────────────────────────────────────────────

final moviesProvider =
    StateNotifierProvider<MoviesNotifier, MoviesState>((ref) {
  return MoviesNotifier(ref.watch(movieRepositoryProvider));
});

// ──────────────────────────────────────────────────────────────────────────────
// Providers auxiliares
// ──────────────────────────────────────────────────────────────────────────────

/// Lista de géneros disponíveis para mostrar nos filtros, reativa ao idioma selecionado.
final availableGenresProvider = FutureProvider<List<String>>((ref) async {
  final langCode = ref.watch(localeProvider).languageCode;
  return ref.watch(movieRepositoryProvider).getAvailableGenres(languageCode: langCode);
});

/// Lista de plataformas disponíveis para mostrar nos filtros.
final availablePlatformsProvider = FutureProvider<List<String>>((ref) async {
  return ref.watch(movieRepositoryProvider).getAvailableStreamingPlatforms();
});

/// Provedor para obter as plataformas onde um filme específico está disponível em Portugal.
final movieWatchProvidersProvider =
    FutureProvider.family<List<String>, String>((ref, movieId) async {
  return ref.watch(movieRepositoryProvider).getMovieStreamingProviders(movieId);
});

/// Estado dos filtros ativos — separado para que os filtros não se percam ao
/// navegar entre ecrãs.
final movieFiltersProvider =
    StateNotifierProvider<MovieFiltersNotifier, MovieFilters>((ref) {
  return MovieFiltersNotifier();
});

class MovieFiltersNotifier extends StateNotifier<MovieFilters> {
  MovieFiltersNotifier() : super(MovieFilters.empty);

  void update(MovieFilters filters) => state = filters;

  void reset() => state = MovieFilters.empty;
}
