import '../../../movies/domain/entities/movie.dart';
import '../entities/ar_trophy_config.dart';

/// Caso de uso que constrói a configuração do troféu AR para o filme vencedor.
class GetArTrophyConfigUseCase {
  const GetArTrophyConfigUseCase();

  ArTrophyConfig execute({
    required Movie winnerMovie,
    required int affirmativeVotes,
    required int totalParticipants,
  }) {
    final String celebrationMessage;
    if (totalParticipants > 0 && affirmativeVotes == totalParticipants) {
      celebrationMessage = 'Consenso Absoluto!';
    } else if (affirmativeVotes > 1) {
      celebrationMessage = 'Filme Mais Votado pelo Grupo!';
    } else {
      celebrationMessage = 'Filme Selecionado!';
    }

    return ArTrophyConfig(
      movieId: winnerMovie.id,
      movieTitle: winnerMovie.title,
      posterPath: winnerMovie.posterPath,
      voteAverage: winnerMovie.rating,
      affirmativeVotes: affirmativeVotes,
      totalParticipants: totalParticipants,
      celebrationMessage: celebrationMessage,
    );
  }
}
