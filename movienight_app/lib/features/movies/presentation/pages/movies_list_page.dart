import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movienight_app/app/theme.dart';
import 'package:movienight_app/features/movies/presentation/providers/movies_provider.dart';
import 'package:movienight_app/features/movies/presentation/widgets/movie_card.dart';
import 'package:movienight_app/features/voting/presentation/pages/voting_page.dart';
import 'package:movienight_app/features/voting/presentation/providers/voting_notifier.dart';
import 'package:movienight_app/features/voting/data/voting_repository_impl.dart';
import 'package:movienight_app/features/voting/domain/entities/voting_session.dart';
import 'package:movienight_app/core/bluetooth/movie_night_peripheral_service.dart';
import 'package:movienight_app/shared/utils/participant_identity_service.dart';
import 'package:movienight_app/shared/widgets/particle_background.dart';
import 'package:movienight_app/l10n/app_localizations.dart';

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
    // Carrega os filmes assim que a página abre, com os filtros ativos
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMovies();
    });
  }

  Future<void> _loadMovies() async {
    final filters = ref.read(movieFiltersProvider);
    await ref.read(moviesProvider.notifier).loadMovies(
          filters: filters,
          sessionId: widget.sessionId,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final moviesState = ref.watch(moviesProvider);

    return Scaffold(
      backgroundColor: MNColors.background,
      body: ParticleBackground(
        particleCount: 25,
        child: SafeArea(
          child: Column(
            children: [
              // AppBar premium
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded,
                          color: MNColors.onBackground),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        l10n.moviesTitle,
                        style: const TextStyle(
                          color: MNColors.onBackground,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (!moviesState.isLoading && moviesState.hasMovies)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: MNColors.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          l10n.moviesCount(moviesState.movies.length),
                          style: const TextStyle(
                            color: MNColors.primaryLight,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Conteúdo
              Expanded(child: _buildBody(context, l10n, moviesState)),

              // Botão votar
              if (moviesState.hasMovies)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: GestureDetector(
                    onTap: _startingVoting ? null : () => _startVoting(context),
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [MNColors.primary, MNColors.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: MNColors.primary.withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.how_to_vote_rounded,
                              color: Colors.white, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            l10n.moviesStartVoting,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
    // Estado: a carregar
    if (state.isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(l10n.moviesLoading),
          ],
        ),
      );
    }

    // Estado: erro
    if (state.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                l10n.moviesError,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                state.errorMessage!,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadMovies,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.moviesRetry),
              ),
            ],
          ),
        ),
      );
    }

    // Estado: sem resultados
    if (state.movies.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.movie_outlined, size: 64),
              const SizedBox(height: 16),
              Text(
                l10n.moviesEmpty,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.tune),
                label: Text(l10n.filtersReset),
              ),
            ],
          ),
        ),
      );
    }

    // Estado: lista de filmes
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
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final movie = state.movies[index];
              return MovieCard(
                movie: movie,
                onTap: () => _showMovieDetails(context, movie),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showMovieDetails(BuildContext context, movie) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.55,
        maxChildSize: 0.9,
        builder: (_, scrollController) => Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: scrollController,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                movie.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.star_rounded, color: Colors.amber[600], size: 18),
                  const SizedBox(width: 4),
                  Text('${movie.rating.toStringAsFixed(1)}  •  '),
                  Text(l10n.movieYear(movie.releaseYear)),
                  if (movie.durationMinutes != null) ...[
                    Text('  •  '),
                    Text(l10n.movieDuration(movie.durationMinutes!)),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: movie.genres.map<Widget>((g) {
                  return Chip(
                    label: Text(g),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero,
                    labelStyle: Theme.of(context).textTheme.labelSmall,
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              Text(
                movie.overview,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (movie.streamingPlatforms.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Disponível em:',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  children: movie.streamingPlatforms.map<Widget>((p) {
                    return Chip(
                      avatar: const Icon(Icons.play_circle_outline, size: 16),
                      label: Text(p),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.zero,
                      labelStyle: Theme.of(context).textTheme.labelSmall,
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startVoting(BuildContext context) async {
    if (_startingVoting) return;

    final movies = ref.read(moviesProvider).movies;
    if (movies.isEmpty) return;

    setState(() => _startingVoting = true);

    // Os filtros são definidos localmente, mas são enviados junto com a
    // lista final para que todos tenham o contexto da votação.
    try {
      final organizerId =
          await ParticipantIdentityService().getParticipantId();
      await VotingRepositoryImpl().saveVotingSession(
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
      // O organizador pode iniciar a própria votação mesmo sem participantes
      // ligados; nesse caso não há ninguém para receber a mensagem.
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

    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => VotingPage(params: params)),
    );

    if (mounted) setState(() => _startingVoting = false);
  }
}
