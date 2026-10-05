import 'package:movienight_app/features/session/domain/entities/session.dart';

/// Contrato do repositório para persistência e gestão do ciclo de vida das sessões.
abstract class SessionRepository {
  /// Regista uma nova sessão.
  Future<void> createSession(Session session);

  /// Guarda ou atualiza o estado de uma sessão existente.
  Future<void> saveSession(Session session);

  /// Recupera uma sessão pelo seu identificador único.
  Future<Session?> getSession(String id);

  /// Recupera a sessão ativa atualmente registada no dispositivo.
  Future<Session?> getActiveSession();

  /// Define a sessão ativa no armazenamento persistente local.
  Future<void> setActiveSession(Session session);

  /// Limpa a sessão ativa atualmente registada.
  Future<void> clearActiveSession();

  /// Adiciona um novo participante à lista de membros de uma sessão.
  Future<void> addParticipant({
    required String sessionId,
    required String participantId,
  });
}
