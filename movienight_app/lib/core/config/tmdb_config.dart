class TmdbConfig {
  TmdbConfig._();

  static const String apiKey = String.fromEnvironment('TMDB_API_KEY');

  static bool get hasValidApiKey =>
      apiKey.isNotEmpty && apiKey != 'your_tmdb_api_key_here';

  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String defaultRegion = 'PT';
  static const String defaultLanguage = 'pt-PT';
}
