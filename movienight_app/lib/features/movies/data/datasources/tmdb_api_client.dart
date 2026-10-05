import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/config/tmdb_config.dart';
import '../../domain/entities/movie_filters.dart';
import '../../domain/exceptions/movie_exceptions.dart';
import '../models/tmdb_movie_dto.dart';
import 'tmdb_genre_catalog.dart';

/// Pure HTTP Client data source for querying The Movie Database (TMDb) REST API v3.
class TmdbApiClient {
  final http.Client _client;

  TmdbApiClient({http.Client? client}) : _client = client ?? http.Client();

  /// Queries the TMDb /discover/movie endpoint with user-defined filters,
  /// returning raw [TmdbMovieDto] items.
  ///
  /// Throws [TmdbApiKeyException] if the API key is not configured.
  /// Throws [TmdbApiException] if the server returns a non-200 status code.
  /// Throws [MovieNetworkException] on connection failure or timeout.
  Future<List<TmdbMovieDto>> discoverMovies(
    MovieFilters filters, {
    String languageCode = 'pt',
  }) async {
    if (!TmdbConfig.hasValidApiKey) {
      throw const TmdbApiKeyException();
    }

    final apiLanguage = languageCode == 'en' ? 'en-US' : 'pt-PT';

    final baseQueryParams = <String, String>{
      'api_key': TmdbConfig.apiKey,
      'language': apiLanguage,
      'sort_by': 'popularity.desc',
      'include_adult': 'false',
      'include_video': 'false',
      'vote_count.gte': '30',
    };

    if (filters.minRating > 0.0) {
      baseQueryParams['vote_average.gte'] = filters.minRating.toString();
    }

    if (filters.minYear != null) {
      baseQueryParams['primary_release_date.gte'] = '${filters.minYear}-01-01';
    }
    if (filters.maxYear != null) {
      baseQueryParams['primary_release_date.lte'] = '${filters.maxYear}-12-31';
    }

    if (filters.maxDurationMinutes != null) {
      baseQueryParams['with_runtime.lte'] = filters.maxDurationMinutes.toString();
    }

    if (filters.genres.isNotEmpty) {
      final genreIds = filters.genres
          .map((g) => TmdbGenreCatalog.genreNameToId[g.toLowerCase().trim()])
          .whereType<int>()
          .toList();
      if (genreIds.isNotEmpty) {
        baseQueryParams['with_genres'] = genreIds.join('|');
      }
    }

    if (filters.streamingPlatforms.isNotEmpty) {
      final providerIds = filters.streamingPlatforms
          .map((p) => TmdbGenreCatalog.providerNameToId[p])
          .whereType<int>()
          .toList();
      if (providerIds.isNotEmpty) {
        baseQueryParams['with_watch_providers'] = providerIds.join('|');
        baseQueryParams['watch_region'] = TmdbConfig.defaultRegion;
      }
    }

    final targetCount = filters.maxResults.clamp(5, 100);
    final pagesNeeded = (targetCount / 20).ceil().clamp(1, 5);

    final allDtos = <TmdbMovieDto>[];

    for (int page = 1; page <= pagesNeeded; page++) {
      final queryParameters = Map<String, String>.from(baseQueryParams);
      queryParameters['page'] = page.toString();

      final uri = Uri.https('api.themoviedb.org', '/3/discover/movie', queryParameters);

      http.Response response;
      try {
        response = await _client.get(uri).timeout(const Duration(seconds: 10));
      } catch (e) {
        if (allDtos.isNotEmpty) break;
        throw MovieNetworkException('Failed to communicate with TMDb: $e');
      }

      if (response.statusCode != 200) {
        if (allDtos.isNotEmpty) break;
        throw TmdbApiException(
          statusCode: response.statusCode,
          responseBody: response.body,
        );
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List? ?? [];
      for (final item in results) {
        if (item is Map<String, dynamic>) {
          allDtos.add(TmdbMovieDto.fromJson(item));
        }
      }

      final totalPages = data['total_pages'] as int? ?? 1;
      if (page >= totalPages) break;
    }

    return allDtos.take(targetCount).toList();
  }

  /// Fetches real-time streaming watch providers in Portugal for a specific movie.
  Future<List<String>> fetchMovieWatchProviders(String movieId) async {
    if (!TmdbConfig.hasValidApiKey) return [];

    try {
      final uri = Uri.https('api.themoviedb.org', '/3/movie/$movieId/watch/providers', {
        'api_key': TmdbConfig.apiKey,
      });

      final response = await _client.get(uri).timeout(const Duration(seconds: 6));
      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = data['results'] as Map<String, dynamic>? ?? {};
      final ptData = results['PT'] as Map<String, dynamic>?;
      if (ptData == null) return [];

      final flatrate = ptData['flatrate'] as List? ?? [];
      return flatrate
          .map((p) => (p as Map<String, dynamic>)['provider_name'] as String?)
          .whereType<String>()
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Synchronizes dynamic genres from TMDb if online, returning localized names.
  Future<List<String>> fetchGenresFromApi({String languageCode = 'pt'}) async {
    if (!TmdbConfig.hasValidApiKey) {
      return getAvailableGenres(languageCode: languageCode);
    }

    try {
      final apiLanguage = languageCode == 'en' ? 'en-US' : 'pt-PT';
      final uri = Uri.https('api.themoviedb.org', '/3/genre/movie/list', {
        'api_key': TmdbConfig.apiKey,
        'language': apiLanguage,
      });

      final response = await _client.get(uri).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final genresList = data['genres'] as List? ?? [];
        final names = genresList
            .map((g) => (g as Map<String, dynamic>)['name'] as String?)
            .whereType<String>()
            .toList();
        if (names.isNotEmpty) return names;
      }
    } catch (_) {}

    return getAvailableGenres(languageCode: languageCode);
  }

  /// Returns available genre labels localized in either 'pt' or 'en'.
  List<String> getAvailableGenres({String languageCode = 'pt'}) {
    return kOfficialTmdbGenres.map((g) => g.localized(languageCode)).toList();
  }

  /// Returns supported streaming platforms in Portugal.
  List<String> getAvailableStreamingPlatforms() {
    return TmdbGenreCatalog.supportedStreamingPlatforms;
  }
}
