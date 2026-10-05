import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:movienight_app/features/movies/domain/entities/movie.dart';

/// Guarda e recupera filmes em cache local por sessão e catálogo global offline.
class MovieLocalDataSource {
  static const String _prefix = 'movienight_movies_';
  static const String _globalCatalogKey = 'movienight_global_catalog';

  String _key(String sessionId) => '$_prefix$sessionId';

  /// Persiste a lista de filmes associada a uma sessão específica.
  Future<void> saveMovies(String sessionId, List<Movie> movies) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(movies.map((m) => m.toJson()).toList());
    await prefs.setString(_key(sessionId), encoded);
  }

  /// Recupera os filmes guardados para uma sessão específica.
  /// Retorna lista vazia se não houver cache.
  Future<List<Movie>> loadMovies(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString(_key(sessionId));

    if (encoded == null) {
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(encoded) as List<dynamic>;
      return decoded
          .map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      await prefs.remove(_key(sessionId));
      return [];
    }
  }

  /// Guarda os filmes descarregados do TMDb como catálogo global offline persistente.
  Future<void> saveLastGlobalCatalog(List<Movie> movies) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(movies.map((m) => m.toJson()).toList());
    await prefs.setString(_globalCatalogKey, encoded);
  }

  /// Recupera o catálogo global TMDb guardado em cache para uso 100% offline.
  Future<List<Movie>> loadLastGlobalCatalog() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString(_globalCatalogKey);
    if (encoded == null) return [];

    try {
      final List<dynamic> decoded = jsonDecode(encoded) as List<dynamic>;
      return decoded
          .map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Apaga os filmes em cache para uma sessão.
  Future<void> clearMovies(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(sessionId));
  }

  /// Verifica se há cache para a sessão.
  Future<bool> hasCache(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_key(sessionId));
  }
}
