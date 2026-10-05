import 'package:movienight_app/features/session/data/datasources/session_local_datasource.dart';
import 'package:movienight_app/features/session/data/models/session_dto.dart';
import 'package:movienight_app/features/session/domain/entities/session.dart';
import 'package:movienight_app/features/session/domain/repositories/session_repository.dart';

/// Implementação do SessionRepository com persistência local via SharedPreferences e cache em memória.
class SessionRepositoryImpl implements SessionRepository {
  final SessionLocalDataSource _localDataSource;
  final Map<String, Session> _memoryCache = {};

  SessionRepositoryImpl({SessionLocalDataSource? localDataSource})
      : _localDataSource = localDataSource ?? SessionLocalDataSource();

  @override
  Future<void> createSession(Session session) async {
    await saveSession(session);
  }

  @override
  Future<void> saveSession(Session session) async {
    _memoryCache[session.id] = session;
    await _localDataSource.saveSession(SessionDto.fromDomain(session));
  }

  @override
  Future<Session?> getSession(String id) async {
    if (_memoryCache.containsKey(id)) {
      return _memoryCache[id];
    }
    final dto = await _localDataSource.getSession(id);
    if (dto != null) {
      final domain = dto.toDomain();
      _memoryCache[id] = domain;
      return domain;
    }
    return null;
  }

  @override
  Future<Session?> getActiveSession() async {
    final dto = await _localDataSource.getActiveSession();
    if (dto != null) {
      final domain = dto.toDomain();
      _memoryCache[domain.id] = domain;
      return domain;
    }
    return null;
  }

  @override
  Future<void> setActiveSession(Session session) async {
    _memoryCache[session.id] = session;
    await _localDataSource.setActiveSession(SessionDto.fromDomain(session));
  }

  @override
  Future<void> clearActiveSession() async {
    await _localDataSource.clearActiveSession();
  }

  @override
  Future<void> addParticipant({
    required String sessionId,
    required String participantId,
  }) async {
    final current = await getSession(sessionId);
    if (current == null) return;
    if (current.participantIds.contains(participantId)) return;

    final updated = current.copyWith(
      participantIds: [...current.participantIds, participantId],
    );
    await saveSession(updated);
  }
}
