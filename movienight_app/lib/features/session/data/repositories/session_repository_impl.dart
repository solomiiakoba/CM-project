import 'package:movienight_app/features/session/domain/entities/session.dart';
import 'package:movienight_app/features/session/domain/repositories/session_repository.dart';

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
