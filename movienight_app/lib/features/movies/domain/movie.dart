class Movie {
  final String id;
  final String title;
  final String overview;
  final String? posterPath; // URL or local asset path
  final int releaseYear;
  final List<String> genres;
  final double rating; // 0.0–10.0
  final int? durationMinutes;
  final List<String> streamingPlatforms;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    required this.releaseYear,
    required this.genres,
    required this.rating,
    this.durationMinutes,
    this.streamingPlatforms = const [],
  });

  Movie copyWith({
    String? id,
    String? title,
    String? overview,
    String? posterPath,
    int? releaseYear,
    List<String>? genres,
    double? rating,
    int? durationMinutes,
    List<String>? streamingPlatforms,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      releaseYear: releaseYear ?? this.releaseYear,
      genres: genres ?? this.genres,
      rating: rating ?? this.rating,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      streamingPlatforms: streamingPlatforms ?? this.streamingPlatforms,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'posterPath': posterPath,
      'releaseYear': releaseYear,
      'genres': genres,
      'rating': rating,
      'durationMinutes': durationMinutes,
      'streamingPlatforms': streamingPlatforms,
    };
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as String,
      title: json['title'] as String,
      overview: json['overview'] as String,
      posterPath: json['posterPath'] as String?,
      releaseYear: json['releaseYear'] as int,
      genres: List<String>.from(json['genres'] as List),
      rating: (json['rating'] as num).toDouble(),
      durationMinutes: json['durationMinutes'] as int?,
      streamingPlatforms: List<String>.from(
        json['streamingPlatforms'] as List? ?? [],
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Movie && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
