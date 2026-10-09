import 'package:flutter/material.dart';

import 'package:movienight_app/features/movies/domain/entities/movie.dart';
import 'package:movienight_app/l10n/app_localizations.dart';
import 'package:movienight_app/shared/widgets/glass_container.dart';

/// Card for a movie — adapts to light and dark theme with glassmorphic styling.
class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;

  const MovieCard({
    super.key,
    required this.movie,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: EdgeInsets.zero,
        borderRadius: 20,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Poster ────────────────────────────────────────────────────
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(20),
                ),
                child: _PosterWidget(
                  posterPath: movie.posterPath,
                  title: movie.title,
                ),
              ),

              // ── Content ───────────────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        movie.title,
                        style: TextStyle(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 6),

                      // Year + duration
                      Row(
                        children: [
                          Icon(Icons.calendar_today_rounded,
                              size: 11, color: cs.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(
                            l10n.movieYear(movie.releaseYear),
                            style: TextStyle(
                              color: cs.onSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                          if (movie.durationMinutes != null) ...[
                            Text('  ·  ',
                                style: TextStyle(
                                    color: cs.onSurfaceVariant, fontSize: 11)),
                            Icon(Icons.schedule_rounded,
                                size: 11, color: cs.onSurfaceVariant),
                            const SizedBox(width: 3),
                            Text(
                              l10n.movieDuration(movie.durationMinutes!),
                              style: TextStyle(
                                color: cs.onSurfaceVariant,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Genre tags
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: movie.genres.take(3).map((g) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: cs.primaryContainer,
                              borderRadius: BorderRadius.circular(6),
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

                      const SizedBox(height: 8),

                      // Overview
                      Text(
                        movie.overview,
                        style: TextStyle(
                          color: cs.onSurfaceVariant,
                          fontSize: 11,
                          height: 1.45,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),

              // ── Rating badge ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 14, 12, 14),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
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
// Poster
// ─────────────────────────────────────────────────────────────────────────────

class _PosterWidget extends StatelessWidget {
  final String? posterPath;
  final String title;

  const _PosterWidget({required this.posterPath, required this.title});

  @override
  Widget build(BuildContext context) {
    if (posterPath != null && posterPath!.startsWith('http')) {
      return SizedBox(
        width: 105,
        height: double.infinity,
        child: Image.network(
          posterPath!,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _placeholder(context),
        ),
      );
    }
    return _placeholder(context);
  }

  Widget _placeholder(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 105,
      height: double.infinity,
      decoration: BoxDecoration(
        color: cs.primaryContainer,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.movie_outlined,
            color: cs.onPrimaryContainer,
            size: 30,
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              title.split(' ').take(2).join(' '),
              style: TextStyle(
                color: cs.onPrimaryContainer,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
