import '../entities/vote.dart';
import '../entities/voting_session.dart';
import '../repositories/voting_repository.dart';

class CastVoteUseCase {
  final VotingRepository _repository;

  CastVoteUseCase(this._repository);

  Future<VotingSession> call({
    required String sessionId,
    required Vote vote,
  }) {
    return _repository.castVote(
      sessionId: sessionId,
      vote: vote,
    );
  }
}
