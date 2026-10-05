import 'package:movienight_app/features/session/domain/entities/session.dart';

/// Data Transfer Object para serialização e persistência de sessões.
class SessionDto {
  final String id;
  final String name;
  final String createdAt;
  final String organizerId;
  final List<String> participantIds;

  const SessionDto({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.organizerId,
    required this.participantIds,
  });

  factory SessionDto.fromJson(Map<String, dynamic> json) {
    final rawId = json['sessionId'] ?? json['id'] ?? '';
    return SessionDto(
      id: rawId.toString(),
      name: (json['name'] ?? 'Movie Night').toString(),
      createdAt: (json['createdAt'] ?? DateTime.now().toIso8601String()).toString(),
      organizerId: (json['organizerId'] ?? '').toString(),
      participantIds: List<String>.from(json['participantIds'] as List? ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sessionId': id,
        'name': name,
        'createdAt': createdAt,
        'organizerId': organizerId,
        'participantIds': participantIds,
      };

  Session toDomain() => Session(
        id: id,
        name: name,
        createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
        organizerId: organizerId,
        participantIds: participantIds,
      );

  factory SessionDto.fromDomain(Session session) => SessionDto(
        id: session.id,
        name: session.name,
        createdAt: session.createdAt.toIso8601String(),
        organizerId: session.organizerId,
        participantIds: session.participantIds,
      );
}
