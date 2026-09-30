import 'package:flutter/material.dart';

import 'package:movienight_app/app/theme.dart';
import 'package:movienight_app/features/movies/domain/movie.dart';
import 'package:movienight_app/l10n/app_localizations.dart';

/// Card premium para um filme — fundo escuro, badge de rating, tags de género.
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

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: MNColors.surfaceVar,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: MNColors.outlineVar),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Poster ──────────────────────────────────────────────────
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(16),
              ),
              child: _PosterWidget(
                posterPath: movie.posterPath,
                title: movie.title,
              ),
            ),

            // ── Conteúdo ─────────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    Text(
                      movie.title,
                      style: const TextStyle(
                        color: MNColors.onBackground,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    // Ano + duração
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded,
                            size: 11, color: MNColors.onSurfaceVar),
                        const SizedBox(width: 4),
                        Text(
                          l10n.movieYear(movie.releaseYear),
                          style: const TextStyle(
                            color: MNColors.onSurfaceVar,
                            fontSize: 11,
                          ),
                        ),
                        if (movie.durationMinutes != null) ...[
                          const Text('  ·  ',
                              style: TextStyle(
                                  color: MNColors.onSurfaceVar, fontSize: 11)),
                          const Icon(Icons.schedule_rounded,
                              size: 11, color: MNColors.onSurfaceVar),
                          const SizedBox(width: 3),
                          Text(
                            l10n.movieDuration(movie.durationMinutes!),
                            style: const TextStyle(
                              color: MNColors.onSurfaceVar,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Géneros
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: movie.genres.take(3).map((g) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: MNColors.primaryContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            g,
                            style: const TextStyle(
                              color: MNColors.onPrimaryContainer,
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
                      style: const TextStyle(
                        color: MNColors.onSurfaceVar,
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
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 5),
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
                ],
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
          errorBuilder: (_, __, ___) => _placeholder(),
        ),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      width: 80,
      height: 115,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [MNColors.primaryContainer, MNColors.surfaceVar],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.movie_outlined,
            color: MNColors.primaryLight,
            size: 26,
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              title.split(' ').take(2).join(' '),
              style: const TextStyle(
                color: MNColors.onPrimaryContainer,
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
