import '../../domain/entities/voting_session.dart';
import 'vote_dto.dart';

class VotingSessionDto {
  final String sessionId;
  final List<String> movieIds;
  final List<VoteDto> votes;

  const VotingSessionDto({
    required this.sessionId,
    required this.movieIds,
    this.votes = const [],
  });

  factory VotingSessionDto.fromDomain(VotingSession session) {
    return VotingSessionDto(
      sessionId: session.sessionId,
      movieIds: session.movieIds,
      votes: session.votes.map((v) => VoteDto.fromDomain(v)).toList(),
    );
  }

  VotingSession toDomain() {
    return VotingSession(
      sessionId: sessionId,
      movieIds: movieIds,
      votes: votes.map((v) => v.toDomain()).toList(),
    );
  }

  factory VotingSessionDto.fromJson(Map<String, dynamic> json) {
    return VotingSessionDto(
      sessionId: json['sessionId'] as String,
      movieIds: List<String>.from(json['movieIds'] as List),
      votes: (json['votes'] as List? ?? [])
          .map((v) => VoteDto.fromJson(v as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'movieIds': movieIds,
      'votes': votes.map((v) => v.toJson()).toList(),
    };
  }
}
