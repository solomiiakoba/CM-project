import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movienight_app/app/theme.dart';
import 'package:movienight_app/features/voting/presentation/providers/voting_notifier.dart';
import 'package:movienight_app/features/movies/domain/movie.dart';
import 'package:movienight_app/l10n/app_localizations.dart';

import 'results_page.dart';

class VotingPage extends ConsumerWidget {
  final VotingParams params;

  const VotingPage({super.key, required this.params});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(votingProvider(params));
    final l10n = AppLocalizations.of(context)!;

    // Navega para resultados quando termina
    if (state.isFinished && state.votingSession != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResultsPage(
              votingSession: state.votingSession!,
              movies: state.movies,
              bleClient: params.bleClient,
            ),
          ),
        );
      });
    }

    final bgColor = _backgroundFor(context, state.gesture);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: state.isFinished
            ? _FinishedView(
                onResults: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ResultsPage(
                      votingSession: state.votingSession!,
                      movies: state.movies,
                      bleClient: params.bleClient,
                    ),
                  ),
                ),
              )
            : _VotingView(params: params, state: state, l10n: l10n),
      ),
    );
  }

  Color _backgroundFor(BuildContext context, TiltGesture gesture) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (gesture) {
      case TiltGesture.right:
        return isDark ? const Color(0xFF0A1F0A) : const Color(0xFFE8F5E9);
      case TiltGesture.left:
        return isDark ? const Color(0xFF1F0A0A) : const Color(0xFFFFEBEE);
      case TiltGesture.none:
        return Theme.of(context).scaffoldBackgroundColor;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Vista principal de votação
// ─────────────────────────────────────────────────────────────────────────────

class _VotingView extends ConsumerWidget {
  final VotingParams params;
  final VotingState state;
  final AppLocalizations l10n;

  const _VotingView({
    required this.params,
    required this.state,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final movie = state.currentMovie!;
    final notifier = ref.read(votingProvider(params).notifier);

    final tiltFraction = (state.tiltX / 10.0).clamp(-1.0, 1.0);
    final rotation = tiltFraction * 0.25;
    final offsetX = tiltFraction * 40.0;

    return Column(
      children: [
        // ── Cabeçalho ──────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.close_rounded,
                    color: cs.onSurface),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Text(
                  l10n.votingTitle,
                  style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // Contador
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Text(
                  '${state.progress + 1} / ${state.total}',
                  style: TextStyle(
                    color: cs.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Barra de progresso ──────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: state.total > 0 ? state.progress / state.total : 0,
              minHeight: 4,
              backgroundColor: cs.outlineVariant,
              valueColor: AlwaysStoppedAnimation(cs.primary),
            ),
          ),
        ),

        // ── Card animado ────────────────────────────────────────────────────
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: GestureDetector(
              onHorizontalDragEnd: (d) {
                if (state.isAnimating) return;
                final v = d.primaryVelocity ?? 0;
                if (v > 300) {
                  notifier.voteByTap(true);
                } else if (v < -300) {
                  notifier.voteByTap(false);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                transform: Matrix4.identity()
                  ..setEntry(0, 3, offsetX)
                  ..rotateZ(rotation),
                transformAlignment: Alignment.bottomCenter,
                child: _MovieVoteCard(
                    movie: movie, gesture: state.gesture),
              ),
            ),
          ),
        ),

        // ── Indicadores de gesto ────────────────────────────────────────────
        _GestureIndicators(gesture: state.gesture, l10n: l10n),

        // ── Botões tácteis ──────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          child: Row(
            children: [
              Expanded(
                child: _VoteButton(
                  icon: Icons.close_rounded,
                  label: l10n.votingSkip,
                  color: const Color(0xFFEF4444),
                  filled: false,
                  onTap: state.isAnimating
                      ? null
                      : () => notifier.voteByTap(false),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _VoteButton(
                  icon: Icons.favorite_rounded,
                  label: l10n.votingLike,
                  color: const Color(0xFF22C55E),
                  filled: true,
                  onTap: state.isAnimating
                      ? null
                      : () => notifier.voteByTap(true),
                ),
              ),
            ],
          ),
        ),

        // ── Dica ────────────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            l10n.votingHint,
            style: TextStyle(
                color: cs.onSurfaceVariant, fontSize: 11),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Card do filme na votação
// ─────────────────────────────────────────────────────────────────────────────

class _MovieVoteCard extends StatelessWidget {
  final Movie movie;
  final TiltGesture gesture;

  const _MovieVoteCard({required this.movie, required this.gesture});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: gesture == TiltGesture.right
              ? const Color(0xFF22C55E).withOpacity(0.6)
              : gesture == TiltGesture.left
                  ? const Color(0xFFEF4444).withOpacity(0.6)
                  : cs.outlineVariant,
          width: gesture != TiltGesture.none ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: gesture == TiltGesture.right
                ? const Color(0xFF22C55E).withOpacity(0.2)
                : gesture == TiltGesture.left
                    ? const Color(0xFFEF4444).withOpacity(0.2)
                    : Colors.black.withOpacity(isDark ? 0.25 : 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Poster / placeholder
          _PosterBackground(posterPath: movie.posterPath),

          // Gradiente inferior para garantir legibilidade dos detalhes
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    (isDark ? MNColors.background : const Color(0xFF0F172A)).withOpacity(0.92),
                  ],
                  stops: const [0.35, 1.0],
                ),
              ),
            ),
          ),

          // Overlay like / skip
          if (gesture == TiltGesture.right)
            const _VoteOverlay(
              label: '❤️  LIKE',
              color: Color(0xFF22C55E),
              alignment: Alignment.topLeft,
            ),
          if (gesture == TiltGesture.left)
            const _VoteOverlay(
              label: '✕  SKIP',
              color: Color(0xFFEF4444),
              alignment: Alignment.topRight,
            ),

          // Informação
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  movie.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFBBF24),
                            Color(0xFFF59E0B)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Colors.white, size: 12),
                          const SizedBox(width: 3),
                          Text(
                            movie.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${movie.releaseYear}',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 13),
                    ),
                    if (movie.durationMinutes != null) ...[
                      const Text('  ·  ',
                          style: TextStyle(
                              color: Colors.white38, fontSize: 13)),
                      Text(
                        '${movie.durationMinutes} min',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 5,
                  runSpacing: 4,
                  children: movie.genres.take(3).map((g) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        g,
                        style: TextStyle(
                          color: cs.onPrimaryContainer,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                Text(
                  movie.overview,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 12, height: 1.4),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PosterBackground extends StatelessWidget {
  final String? posterPath;
  const _PosterBackground({this.posterPath});

  @override
  Widget build(BuildContext context) {
    if (posterPath != null && posterPath!.startsWith('http')) {
      return Image.network(
        posterPath!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(context),
      );
    }
    return _placeholder(context);
  }

  Widget _placeholder(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.primaryContainer,
      ),
      child: Center(
        child: Icon(Icons.movie_outlined, size: 72,
            color: cs.onPrimaryContainer),
      ),
    );
  }
}

class _VoteOverlay extends StatelessWidget {
  final String label;
  final Color color;
  final Alignment alignment;

  const _VoteOverlay({
    required this.label,
    required this.color,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Transform.rotate(
            angle: alignment == Alignment.topLeft ? -0.3 : 0.3,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                border: Border.all(color: color, width: 2.5),
                borderRadius: BorderRadius.circular(10),
                color: color.withOpacity(0.08),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Indicadores de gesto
// ─────────────────────────────────────────────────────────────────────────────

class _GestureIndicators extends StatelessWidget {
  final TiltGesture gesture;
  final AppLocalizations l10n;

  const _GestureIndicators({required this.gesture, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final defaultColor = cs.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnimatedOpacity(
            opacity: gesture == TiltGesture.left ? 1.0 : 0.3,
            duration: const Duration(milliseconds: 200),
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios_rounded,
                    size: 14,
                    color: gesture == TiltGesture.left
                        ? const Color(0xFFEF4444)
                        : defaultColor),
                const SizedBox(width: 4),
                Text(
                  l10n.votingSkip,
                  style: TextStyle(
                    color: gesture == TiltGesture.left
                        ? const Color(0xFFEF4444)
                        : defaultColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          AnimatedOpacity(
            opacity: gesture == TiltGesture.right ? 1.0 : 0.3,
            duration: const Duration(milliseconds: 200),
            child: Row(
              children: [
                Text(
                  l10n.votingLike,
                  style: TextStyle(
                    color: gesture == TiltGesture.right
                        ? const Color(0xFF22C55E)
                        : defaultColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: gesture == TiltGesture.right
                        ? const Color(0xFF22C55E)
                        : defaultColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Botão de voto táctil
// ─────────────────────────────────────────────────────────────────────────────

class _VoteButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool filled;
  final VoidCallback? onTap;

  const _VoteButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.filled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: onTap == null ? 0.4 : 1.0,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: filled ? color.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.6), width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Vista de fim de votação
// ─────────────────────────────────────────────────────────────────────────────

class _FinishedView extends StatelessWidget {
  final VoidCallback onResults;
  const _FinishedView({required this.onResults});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [MNColors.primary, MNColors.secondary],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: MNColors.primary.withOpacity(0.4),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: const Icon(Icons.celebration_rounded,
                  color: Colors.white, size: 40),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.votingFinished,
              style: TextStyle(
                color: cs.onSurface,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: onResults,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [MNColors.primary, MNColors.secondary],
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.leaderboard_rounded,
                        color: Colors.white),
                    const SizedBox(width: 10),
                    Text(
                      l10n.votingGoToResults,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
