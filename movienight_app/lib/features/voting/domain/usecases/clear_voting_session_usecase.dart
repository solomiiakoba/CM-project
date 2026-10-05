import '../repositories/voting_repository.dart';

class ClearVotingSessionUseCase {
  final VotingRepository _repository;

  ClearVotingSessionUseCase(this._repository);

  Future<void> call(String sessionId) {
    return _repository.clearVotingSession(sessionId);
  }
}
