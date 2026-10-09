import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/ar_capability_service_impl.dart';
import '../../domain/entities/ar_trophy_config.dart';
import '../../domain/services/ar_capability_service.dart';
import '../../domain/usecases/get_ar_trophy_config_usecase.dart';
import '../../../movies/domain/entities/movie.dart';

export '../../domain/entities/ar_trophy_config.dart';

/// Provider do serviço de capacidade AR.
final arCapabilityServiceProvider = Provider<ArCapabilityService>((ref) {
  return ArCapabilityServiceImpl();
});

/// Provider que verifica de forma assíncrona o suporte AR no dispositivo.
final arSupportedProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(arCapabilityServiceProvider);
  return service.isArSupported();
});

/// Provider do UseCase que constrói a configuração do troféu.
final getArTrophyConfigUseCaseProvider = Provider<GetArTrophyConfigUseCase>((ref) {
  return const GetArTrophyConfigUseCase();
});

/// Família de Providers para construir uma instância de ArTrophyConfig a partir dos parâmetros do filme vencedor.
final arTrophyConfigFamily = Provider.family<ArTrophyConfig, ({Movie winnerMovie, int affirmativeVotes, int totalParticipants})>(
  (ref, params) {
    final useCase = ref.watch(getArTrophyConfigUseCaseProvider);
    return useCase.execute(
      winnerMovie: params.winnerMovie,
      affirmativeVotes: params.affirmativeVotes,
      totalParticipants: params.totalParticipants,
    );
  },
);
