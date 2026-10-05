import '../entities/voting_session.dart';
import '../repositories/voting_repository.dart';

class GetVotingSessionUseCase {
  final VotingRepository _repository;

  GetVotingSessionUseCase(this._repository);

  Future<VotingSession?> call(String sessionId) {
    return _repository.loadVotingSession(sessionId);
  }
}
