import '../domain/session.dart';
import '../domain/session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  final Map<String, Session> _sessions = {};

  @override
  Future<void> createSession(Session session) async {
    _sessions[session.id] = session;
  }

  @override
  Future<Session?> getSession(String id) async {
    return _sessions[id];
  }
}