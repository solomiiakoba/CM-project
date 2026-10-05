import '../entities/voting_session.dart';
import '../repositories/voting_repository.dart';

class SaveVotingSessionUseCase {
  final VotingRepository _repository;

  SaveVotingSessionUseCase(this._repository);

  Future<void> call(VotingSession session) {
    return _repository.saveVotingSession(session);
  }
}
