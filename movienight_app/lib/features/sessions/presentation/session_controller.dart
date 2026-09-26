import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/session_repository_impl.dart';
import '../domain/session.dart';
import '../domain/session_repository.dart';

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SessionRepositoryImpl();
});

final sessionControllerProvider = Provider<SessionController>((ref) {
  return SessionController(
    ref.read(sessionRepositoryProvider),
  );
});

class SessionController {
  final SessionRepository repository;

  SessionController(this.repository);

  Future<Session> createSession({
    required String name,
  }) async {
    final session = Session(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      createdAt: DateTime.now(),
      organizerId: 'user-1',
    );

    await repository.createSession(session);

    return session;
  }
}