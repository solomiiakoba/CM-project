import '../../domain/entities/genre.dart';

/// Official catalog of all 19 movie genres defined in TMDb.
const List<Genre> kOfficialTmdbGenres = [
  Genre(id: 28, namePt: 'Ação', nameEn: 'Action'),
  Genre(id: 12, namePt: 'Aventura', nameEn: 'Adventure'),
  Genre(id: 16, namePt: 'Animação', nameEn: 'Animation'),
  Genre(id: 35, namePt: 'Comédia', nameEn: 'Comedy'),
  Genre(id: 80, namePt: 'Crime', nameEn: 'Crime'),
  Genre(id: 99, namePt: 'Documentário', nameEn: 'Documentary'),
  Genre(id: 18, namePt: 'Drama', nameEn: 'Drama'),
  Genre(id: 10751, namePt: 'Família', nameEn: 'Family'),
  Genre(id: 14, namePt: 'Fantasia', nameEn: 'Fantasy'),
  Genre(id: 36, namePt: 'História', nameEn: 'History'),
  Genre(id: 27, namePt: 'Terror', nameEn: 'Horror'),
  Genre(id: 10402, namePt: 'Música', nameEn: 'Music'),
  Genre(id: 9648, namePt: 'Mistério', nameEn: 'Mystery'),
  Genre(id: 10749, namePt: 'Romance', nameEn: 'Romance'),
  Genre(id: 878, namePt: 'Ficção científica', nameEn: 'Sci-Fi'),
  Genre(id: 10770, namePt: 'Cinema TV', nameEn: 'TV Movie'),
  Genre(id: 53, namePt: 'Thriller', nameEn: 'Thriller'),
  Genre(id: 10752, namePt: 'Guerra', nameEn: 'War'),
  Genre(id: 37, namePt: 'Faroeste', nameEn: 'Western'),
];

/// Helper class providing fast lookups for TMDb genres and provider IDs.
class TmdbGenreCatalog {
  TmdbGenreCatalog._();

  /// Canonical mapping between localized genre labels and TMDb integer IDs.
  static final Map<String, int> genreNameToId = {
    for (final g in kOfficialTmdbGenres) ...{
      g.namePt.toLowerCase(): g.id,
      g.nameEn.toLowerCase(): g.id,
      if (g.id == 878) 'science fiction': 878,
      if (g.id == 36) 'biography': 36,
      if (g.id == 36) 'biografia': 36,
    }
  };

  /// Lookup map from genre ID to Genre entity.
  static final Map<int, Genre> genreIdToEntity = {
    for (final g in kOfficialTmdbGenres) g.id: g,
  };

  /// Canonical mapping between streaming platforms in Portugal and TMDb Provider IDs.
  static const Map<String, int> providerNameToId = {
    'Netflix': 8,
    'Disney+': 337,
    'HBO Max': 1899,
    'Max': 1899,
    'Amazon Prime': 119,
    'Amazon Prime Video': 119,
    'Paramount+': 531,
    'Apple TV+': 350,
  };

  /// Available streaming platforms list.
  static const List<String> supportedStreamingPlatforms = [
    'Netflix',
    'Disney+',
    'HBO Max',
    'Amazon Prime',
    'Paramount+',
    'Apple TV+',
  ];
}
