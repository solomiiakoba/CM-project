import '../../domain/entities/vote.dart';

class VoteDto {
  final String movieId;
  final String participantId;
  final bool liked;
  final String votedAt;

  const VoteDto({
    required this.movieId,
    required this.participantId,
    required this.liked,
    required this.votedAt,
  });

  factory VoteDto.fromDomain(Vote vote) {
    return VoteDto(
      movieId: vote.movieId,
      participantId: vote.participantId,
      liked: vote.liked,
      votedAt: vote.votedAt.toIso8601String(),
    );
  }

  Vote toDomain() {
    return Vote(
      movieId: movieId,
      participantId: participantId,
      liked: liked,
      votedAt: DateTime.parse(votedAt),
    );
  }

  factory VoteDto.fromJson(Map<String, dynamic> json) {
    return VoteDto(
      movieId: json['movieId'] as String,
      participantId: json['participantId'] as String,
      liked: json['liked'] as bool,
      votedAt: json['votedAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movieId': movieId,
      'participantId': participantId,
      'liked': liked,
      'votedAt': votedAt,
    };
  }
}
