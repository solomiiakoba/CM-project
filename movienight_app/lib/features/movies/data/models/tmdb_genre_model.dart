import '../../domain/entities/genre.dart';

/// Model for deserializing genre items from TMDb's `/genre/movie/list` endpoint.
class TmdbGenreModel {
  final int id;
  final String name;

  const TmdbGenreModel({
    required this.id,
    required this.name,
  });

  factory TmdbGenreModel.fromJson(Map<String, dynamic> json) {
    return TmdbGenreModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }

  /// Converts to domain [Genre] entity with fallback.
  Genre toDomain({String languageCode = 'pt'}) {
    return Genre(
      id: id,
      namePt: languageCode == 'pt' ? name : '',
      nameEn: languageCode == 'en' ? name : '',
    );
  }
}
