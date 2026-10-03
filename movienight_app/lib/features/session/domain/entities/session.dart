class Session {
  final String id;
  final String name;
  final DateTime createdAt;
  final String organizerId;
  final List<String> participantIds;

  const Session({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.organizerId,
    this.participantIds = const [],
  });

  Session copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    String? organizerId,
    List<String>? participantIds,
  }) {
    return Session(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      organizerId: organizerId ?? this.organizerId,
      participantIds: participantIds ?? this.participantIds,
    );
  }

  // ─── Serialização JSON (usada no QR code e BLE) ──────────────────────────

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'createdAt': createdAt.toIso8601String(),
        'organizerId': organizerId,
        'participantIds': participantIds,
      };

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        id: json['id'] as String,
        name: json['name'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        organizerId: json['organizerId'] as String,
        participantIds:
            List<String>.from(json['participantIds'] as List? ?? []),
      );
}
