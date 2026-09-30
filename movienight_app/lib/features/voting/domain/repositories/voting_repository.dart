import '../entities/vote.dart';
import '../entities/voting_session.dart';

abstract class VotingRepository {
  /// Cria ou substitui a sessão de votação.
  Future<void> saveVotingSession(VotingSession session);

  /// Carrega a sessão de votação. Retorna null se não existir.
  Future<VotingSession?> loadVotingSession(String sessionId);

  /// Regista um voto e persiste.
  Future<VotingSession> castVote({
    required String sessionId,
    required Vote vote,
  });

  /// Apaga a sessão de votação.
  Future<void> clearVotingSession(String sessionId);
}
