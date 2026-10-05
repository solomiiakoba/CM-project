/// Exceção base para erros relacionados com a gestão de sessões.
sealed class SessionException implements Exception {
  final String message;
  const SessionException(this.message);

  @override
  String toString() => message;
}

/// Lançada quando uma sessão pesquisada não é encontrada.
class SessionNotFoundException extends SessionException {
  final String sessionId;

  const SessionNotFoundException(this.sessionId)
      : super('Sessão com o ID "$sessionId" não foi encontrada.');
}

/// Lançada quando os dados do QR code lido são inválidos ou corrompidos.
class InvalidSessionQrException extends SessionException {
  const InvalidSessionQrException([
    String message = 'O código QR lido não corresponde a uma sessão válida do MovieNight.',
  ]) : super(message);
}

/// Lançada quando ocorre uma falha na persistência local da sessão.
class SessionStorageException extends SessionException {
  const SessionStorageException(String message) : super(message);
}
