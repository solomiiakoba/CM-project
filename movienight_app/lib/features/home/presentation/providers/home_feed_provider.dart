import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movienight_app/shared/providers/locale_provider.dart';

import '../../../movies/presentation/providers/movies_provider.dart';
import '../../domain/entities/home_feed.dart';
import '../../domain/usecases/get_home_feed_usecase.dart';

export '../../domain/entities/home_feed.dart';

/// Estado do feed da Home.
class HomeFeedState {
  final HomeFeed feed;
  final bool isLoading;
  final String? errorMessage;

  const HomeFeedState({
    this.feed = const HomeFeed(),
    this.isLoading = false,
    this.errorMessage,
  });

  HomeFeedState copyWith({
    HomeFeed? feed,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HomeFeedState(
      feed: feed ?? this.feed,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// Notifier que gere o ciclo de vida e atualização do feed da Home.
class HomeFeedNotifier extends StateNotifier<HomeFeedState> {
  final GetHomeFeedUseCase _getHomeFeedUseCase;
  final Ref _ref;

  HomeFeedNotifier({
    required GetHomeFeedUseCase getHomeFeedUseCase,
    required Ref ref,
  })  : _getHomeFeedUseCase = getHomeFeedUseCase,
        _ref = ref,
        super(const HomeFeedState(isLoading: true)) {
    loadFeed();
  }

  Future<void> loadFeed() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final languageCode = _ref.read(localeProvider).languageCode;
      final feed = await _getHomeFeedUseCase.execute(languageCode: languageCode);

      state = state.copyWith(
        feed: feed,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refresh() => loadFeed();
}

/// Provider do UseCase GetHomeFeedUseCase.
final getHomeFeedUseCaseProvider = Provider<GetHomeFeedUseCase>((ref) {
  final movieRepository = ref.watch(movieRepositoryProvider);
  return GetHomeFeedUseCase(movieRepository);
});

/// Provider de estado do feed da Home.
final homeFeedProvider = StateNotifierProvider<HomeFeedNotifier, HomeFeedState>((ref) {
  final useCase = ref.watch(getHomeFeedUseCaseProvider);
  return HomeFeedNotifier(
    getHomeFeedUseCase: useCase,
    ref: ref,
  );
});
