import '../../../../core/bluetooth/movie_night_ble_client.dart';
import '../../../../core/bluetooth/movie_night_peripheral_service.dart';
import '../../../movies/domain/entities/movie.dart';

class VotingParams {
  final String sessionId;
  final List<Movie> movies;
  final String participantId;
  final MovieNightBleClient? bleClient;
  final MovieNightPeripheralService? peripheralService;

  const VotingParams({
    required this.sessionId,
    required this.movies,
    required this.participantId,
    this.bleClient,
    this.peripheralService,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VotingParams && other.sessionId == sessionId;

  @override
  int get hashCode => sessionId.hashCode;
}
