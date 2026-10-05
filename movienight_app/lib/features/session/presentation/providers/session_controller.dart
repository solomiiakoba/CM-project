import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movienight_app/features/session/data/repositories/session_repository_impl.dart';
import 'package:movienight_app/features/session/domain/entities/session.dart';
import 'package:movienight_app/features/session/domain/repositories/session_repository.dart';
import 'package:movienight_app/features/session/domain/usecases/create_session_usecase.dart';
import 'package:movienight_app/features/session/domain/usecases/get_active_session_usecase.dart';
import 'package:movienight_app/features/session/domain/usecases/parse_qr_session_usecase.dart';
import 'package:movienight_app/shared/utils/participant_identity_service.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Providers de Repositório e Casos de Uso
// ──────────────────────────────────────────────────────────────────────────────

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SessionRepositoryImpl();
});

final createSessionUseCaseProvider = Provider<CreateSessionUseCase>((ref) {
  return CreateSessionUseCase(
    repository: ref.read(sessionRepositoryProvider),
    identityService: ParticipantIdentityService(),
  );
});

final parseQrSessionUseCaseProvider = Provider<ParseQrSessionUseCase>((ref) {
  return const ParseQrSessionUseCase();
});

final getActiveSessionUseCaseProvider = Provider<GetActiveSessionUseCase>((ref) {
  return GetActiveSessionUseCase(
    ref.read(sessionRepositoryProvider),
  );
});

// ──────────────────────────────────────────────────────────────────────────────
// SessionController (Consome CreateSessionUseCase sem ID hardcoded)
// ──────────────────────────────────────────────────────────────────────────────

final sessionControllerProvider = Provider<SessionController>((ref) {
  return SessionController(
    ref.read(createSessionUseCaseProvider),
    ref.read(sessionRepositoryProvider),
  );
});

class SessionController {
  final CreateSessionUseCase _createSessionUseCase;
  final SessionRepository repository;

  SessionController(
    this._createSessionUseCase,
    this.repository,
  );

  Future<Session> createSession({
    required String name,
  }) async {
    return _createSessionUseCase.execute(name: name);
  }
}
