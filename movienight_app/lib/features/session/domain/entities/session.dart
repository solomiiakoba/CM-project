import 'package:movienight_app/features/movies/domain/movie_filters.dart';

class Session {
  final String id;
  final String name;
  final DateTime createdAt;
  final String organizerId;
  final List<String> participantIds;

  /// Filtros que o organizador configurou.
  /// Transmitidos via QR code e BLE para que os participantes
  /// possam carregar os mesmos filmes.
  final MovieFilters filters;

  const Session({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.organizerId,
    this.participantIds = const [],
    this.filters = MovieFilters.empty,
  });

  Session copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    String? organizerId,
    List<String>? participantIds,
    MovieFilters? filters,
  }) {
    return Session(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      organizerId: organizerId ?? this.organizerId,
      participantIds: participantIds ?? this.participantIds,
      filters: filters ?? this.filters,
    );
  }

  // ─── Serialização JSON (usada no QR code e BLE) ──────────────────────────

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'createdAt': createdAt.toIso8601String(),
        'organizerId': organizerId,
        'participantIds': participantIds,
        'filters': filters.toJson(),
      };

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        id: json['id'] as String,
        name: json['name'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        organizerId: json['organizerId'] as String,
        participantIds:
            List<String>.from(json['participantIds'] as List? ?? []),
        filters: json['filters'] != null
            ? MovieFilters.fromJson(json['filters'] as Map<String, dynamic>)
            : MovieFilters.empty,
      );
}
