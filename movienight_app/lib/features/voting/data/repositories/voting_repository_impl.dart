import '../../domain/entities/vote.dart';
import '../../domain/entities/voting_session.dart';
import '../../domain/exceptions/voting_exceptions.dart';
import '../../domain/repositories/voting_repository.dart';
import '../datasources/voting_local_datasource.dart';
import '../models/voting_session_dto.dart';

class VotingRepositoryImpl implements VotingRepository {
  final VotingLocalDataSource _localDataSource;

  VotingRepositoryImpl(this._localDataSource);

  @override
  Future<void> saveVotingSession(VotingSession session) async {
    final dto = VotingSessionDto.fromDomain(session);
    await _localDataSource.saveVotingSession(dto);
  }

  @override
  Future<VotingSession?> loadVotingSession(String sessionId) async {
    final dto = await _localDataSource.loadVotingSession(sessionId);
    return dto?.toDomain();
  }

  @override
  Future<VotingSession> castVote({
    required String sessionId,
    required Vote vote,
  }) async {
    final existing = await loadVotingSession(sessionId);
    if (existing == null) {
      throw VotingSessionNotFoundException(sessionId);
    }
    final updated = existing.addVote(vote);
    await saveVotingSession(updated);
    return updated;
  }

  @override
  Future<void> clearVotingSession(String sessionId) async {
    await _localDataSource.clearVotingSession(sessionId);
  }
}
