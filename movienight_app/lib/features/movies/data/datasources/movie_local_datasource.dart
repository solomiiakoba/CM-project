import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:movienight_app/features/movies/domain/movie.dart';

/// Guarda e recupera filmes em cache local por sessão.
class MovieLocalDataSource {
  static const String _prefix = 'movienight_movies_';

  String _key(String sessionId) => '$_prefix$sessionId';

  /// Persiste a lista de filmes associada a uma sessão.
  Future<void> saveMovies(String sessionId, List<Movie> movies) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(movies.map((m) => m.toJson()).toList());
    await prefs.setString(_key(sessionId), encoded);
  }

  /// Recupera os filmes guardados para uma sessão.
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
      // Cache corrompida — limpar e devolver vazio
      await prefs.remove(_key(sessionId));
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
