/// Base class for all voting-related exceptions.
abstract class VotingException implements Exception {
  final String message;
  const VotingException(this.message);

  @override
  String toString() => message;
}

class VotingSessionNotFoundException extends VotingException {
  const VotingSessionNotFoundException(String sessionId)
      : super('Voting session $sessionId not found.');
}

class VotingStorageException extends VotingException {
  const VotingStorageException(super.message);
}
