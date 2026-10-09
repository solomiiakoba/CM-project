import 'package:movienight_app/features/session/domain/entities/session.dart';
import 'package:movienight_app/features/session/domain/repositories/session_repository.dart';
import 'package:movienight_app/shared/utils/participant_identity_service.dart';

/// Caso de uso responsável por instanciar e inicializar uma nova sessão MovieNight.
class CreateSessionUseCase {
  final SessionRepository _repository;
  final ParticipantIdentityService _identityService;

  CreateSessionUseCase({
    required this._repository,
    ParticipantIdentityService? identityService,
  })  : _identityService = identityService ?? ParticipantIdentityService();

  Future<Session> execute({required String name}) async {
    final organizerId = await _identityService.getParticipantId();
    final now = DateTime.now();

    final session = Session(
      id: now.millisecondsSinceEpoch.toString(),
      name: name.trim(),
      createdAt: now,
      organizerId: organizerId,
      participantIds: const [],
    );

    await _repository.createSession(session);
    await _repository.setActiveSession(session);

    return session;
  }
}
