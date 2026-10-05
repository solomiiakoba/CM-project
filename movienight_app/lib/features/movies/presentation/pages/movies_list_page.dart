import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movienight_app/core/bluetooth/movie_night_peripheral_service.dart';
import 'package:movienight_app/features/movies/presentation/providers/movies_provider.dart';
import 'package:movienight_app/features/movies/presentation/widgets/gradient_action_button.dart';
import 'package:movienight_app/features/movies/presentation/widgets/movie_card.dart';
import 'package:movienight_app/features/movies/presentation/widgets/movie_count_badge.dart';
import 'package:movienight_app/features/movies/presentation/widgets/movie_details_bottom_sheet.dart';
import 'package:movienight_app/features/movies/presentation/widgets/movie_page_header.dart';
import 'package:movienight_app/features/movies/presentation/widgets/movies_state_views.dart';
import 'package:movienight_app/features/voting/domain/entities/voting_session.dart';
import 'package:movienight_app/features/voting/presentation/pages/voting_page.dart';
import 'package:movienight_app/features/voting/presentation/providers/voting_providers.dart';
import 'package:movienight_app/l10n/app_localizations.dart';
import 'package:movienight_app/shared/providers/locale_provider.dart';
import 'package:movienight_app/shared/utils/participant_identity_service.dart';
import 'package:movienight_app/shared/widgets/particle_background.dart';

/// Ecrã que apresenta a listagem de filmes descobertos com base nos filtros selecionados.
class MoviesListPage extends ConsumerStatefulWidget {
  final String sessionId;

  const MoviesListPage({
    super.key,
    required this.sessionId,
  });

  @override
  ConsumerState<MoviesListPage> createState() => _MoviesListPageState();
}

class _MoviesListPageState extends ConsumerState<MoviesListPage> {
  final MovieNightPeripheralService _peripheralService =
      MovieNightPeripheralService();
  bool _startingVoting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMovies();
    });
  }

  Future<void> _loadMovies() async {
    final filters = ref.read(movieFiltersProvider);
    final lang = ref.read(localeProvider).languageCode;
    await ref.read(moviesProvider.notifier).loadMovies(
          filters: filters,
          sessionId: widget.sessionId,
          languageCode: lang,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final moviesState = ref.watch(moviesProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ParticleBackground(
        particleCount: 25,
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ──────────────────────────────────────────────────
              MoviePageHeader(
                title: l10n.moviesTitle,
                trailing: (!moviesState.isLoading && moviesState.hasMovies)
                    ? MovieCountBadge(
                        label: l10n.moviesCount(moviesState.movies.length),
                      )
                    : null,
              ),

              // ── Body ────────────────────────────────────────────────────
              Expanded(child: _buildBody(context, l10n, moviesState)),

              // ── Vote button ──────────────────────────────────────────────
              if (moviesState.hasMovies)
                GradientActionButton(
                  label: l10n.moviesStartVoting,
                  icon: Icons.how_to_vote_rounded,
                  isLoading: _startingVoting,
                  onTap: _startVoting,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations l10n,
    MoviesState state,
  ) {
    if (state.isLoading) {
      return const MoviesLoadingView();
    }

    if (state.hasError) {
      return MoviesErrorView(
        errorMessage: state.errorMessage!,
        onRetry: _loadMovies,
      );
    }

    if (state.movies.isEmpty) {
      return MoviesEmptyView(
        onAdjustFilters: () => Navigator.pop(context),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            l10n.moviesSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            itemCount: state.movies.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final movie = state.movies[index];
              return MovieCard(
                movie: movie,
                onTap: () => MovieDetailsBottomSheet.show(context, movie),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _startVoting() async {
    if (_startingVoting) return;

    final movies = ref.read(moviesProvider).movies;
    if (movies.isEmpty) return;

    setState(() => _startingVoting = true);

    try {
      final organizerId =
          await ParticipantIdentityService().getParticipantId();
      await ref.read(saveVotingSessionUseCaseProvider)(
        VotingSession(
          sessionId: widget.sessionId,
          movieIds: movies.map((movie) => movie.id).toList(),
        ),
      );
      await _peripheralService.sendMessage({
        'type': 'voting_started',
        'sessionId': widget.sessionId,
        'organizerId': organizerId,
        'filters': ref.read(movieFiltersProvider).toJson(),
        'movies': movies.map((movie) => movie.toJson()).toList(),
      });
    } catch (_) {
      // Organizer can start voting without participants connected
    }

    final participantId =
        await ParticipantIdentityService().getParticipantId();

    if (!mounted) return;

    final params = VotingParams(
      sessionId: widget.sessionId,
      movies: movies,
      participantId: participantId,
      peripheralService: _peripheralService,
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => VotingPage(params: params)),
    );

    if (mounted) setState(() => _startingVoting = false);
  }
}
