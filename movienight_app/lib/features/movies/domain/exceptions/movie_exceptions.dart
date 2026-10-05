/// Base exception for movies feature.
abstract class MovieException implements Exception {
  final String message;
  const MovieException(this.message);

  @override
  String toString() => message;
}

/// Thrown when TMDb API returns an HTTP error status code.
class TmdbApiException extends MovieException {
  final int statusCode;
  final String responseBody;

  const TmdbApiException({
    required this.statusCode,
    required this.responseBody,
  }) : super('TMDb API Error (HTTP $statusCode): $responseBody');
}

/// Thrown when the TMDb API key is missing or not configured.
class TmdbApiKeyException extends MovieException {
  const TmdbApiKeyException()
      : super('TMDb API key is not configured. Please supply TMDB_API_KEY in .env');
}

/// Thrown on network timeout or connection failure.
class MovieNetworkException extends MovieException {
  const MovieNetworkException([super.message = 'Network error while contacting TMDb.']);
}
