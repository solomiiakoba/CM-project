import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/voting_local_datasource.dart';
import '../../data/repositories/voting_repository_impl.dart';
import '../../domain/repositories/voting_repository.dart';
import '../../domain/usecases/cast_vote_usecase.dart';
import '../../domain/usecases/clear_voting_session_usecase.dart';
import '../../domain/usecases/get_voting_session_usecase.dart';
import '../../domain/usecases/save_voting_session_usecase.dart';
import 'voting_notifier.dart';

export 'voting_notifier.dart';
export 'voting_params.dart';
export 'voting_state.dart';

final votingLocalDataSourceProvider = Provider<VotingLocalDataSource>((ref) {
  return VotingLocalDataSourceImpl();
});

final votingRepositoryProvider = Provider<VotingRepository>((ref) {
  final dataSource = ref.watch(votingLocalDataSourceProvider);
  return VotingRepositoryImpl(dataSource);
});

final saveVotingSessionUseCaseProvider = Provider<SaveVotingSessionUseCase>((ref) {
  final repository = ref.watch(votingRepositoryProvider);
  return SaveVotingSessionUseCase(repository);
});

final getVotingSessionUseCaseProvider = Provider<GetVotingSessionUseCase>((ref) {
  final repository = ref.watch(votingRepositoryProvider);
  return GetVotingSessionUseCase(repository);
});

final castVoteUseCaseProvider = Provider<CastVoteUseCase>((ref) {
  final repository = ref.watch(votingRepositoryProvider);
  return CastVoteUseCase(repository);
});

final clearVotingSessionUseCaseProvider = Provider<ClearVotingSessionUseCase>((ref) {
  final repository = ref.watch(votingRepositoryProvider);
  return ClearVotingSessionUseCase(repository);
});

final votingProvider = StateNotifierProvider.family<
    VotingNotifier, VotingState, VotingParams>((ref, params) {
  final saveVotingSession = ref.watch(saveVotingSessionUseCaseProvider);
  final getVotingSession = ref.watch(getVotingSessionUseCaseProvider);
  final castVote = ref.watch(castVoteUseCaseProvider);

  final notifier = VotingNotifier(
    saveVotingSession: saveVotingSession,
    getVotingSession: getVotingSession,
    castVote: castVote,
    initialState: VotingState(
      movies: params.movies,
      participantId: params.participantId,
    ),
    bleClient: params.bleClient,
    peripheralService: params.peripheralService,
  );

  notifier.startSession(
    sessionId: params.sessionId,
    movies: params.movies,
    participantId: params.participantId,
  );
  return notifier;
});
