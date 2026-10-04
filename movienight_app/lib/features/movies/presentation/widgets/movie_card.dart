import 'package:flutter/material.dart';

import 'package:movienight_app/app/theme.dart';
import 'package:movienight_app/features/movies/domain/movie.dart';
import 'package:movienight_app/l10n/app_localizations.dart';

/// Card for a movie — adapts to light and dark theme.
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.25 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Poster ────────────────────────────────────────────────────
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(16),
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
          ],
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
        width: 80,
        height: 115,
        child: Image.network(
          posterPath!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(context),
        ),
      );
    }
    return _placeholder(context);
  }

  Widget _placeholder(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 80,
      height: 115,
      decoration: BoxDecoration(
        color: cs.primaryContainer,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.movie_outlined,
            color: cs.onPrimaryContainer,
            size: 26,
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              title.split(' ').take(2).join(' '),
              style: TextStyle(
                color: cs.onPrimaryContainer,
                fontSize: 9,
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
