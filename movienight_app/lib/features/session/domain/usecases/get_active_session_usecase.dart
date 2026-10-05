import 'package:movienight_app/features/session/domain/entities/session.dart';
import 'package:movienight_app/features/session/domain/repositories/session_repository.dart';

/// Caso de uso para recuperar a sessão atualmente ativa no dispositivo.
class GetActiveSessionUseCase {
  final SessionRepository _repository;

  const GetActiveSessionUseCase(this._repository);

  Future<Session?> execute() => _repository.getActiveSession();
}
