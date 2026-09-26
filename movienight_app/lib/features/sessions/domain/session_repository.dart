import 'session.dart';

abstract class SessionRepository {
  Future<void> createSession(Session session);

  Future<Session?> getSession(String id);
}