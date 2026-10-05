import 'package:flutter/material.dart';

import 'package:movienight_app/features/movies/domain/entities/movie.dart';
import 'package:movienight_app/features/movies/presentation/widgets/movie_streaming_providers_section.dart';
import 'package:movienight_app/l10n/app_localizations.dart';

/// Modal bottom sheet que apresenta os detalhes completos de um filme.
class MovieDetailsBottomSheet extends StatelessWidget {
  final Movie movie;

  const MovieDetailsBottomSheet({
    super.key,
    required this.movie,
  });

  /// Utilitário estático para exibir a folha modal de detalhes do filme.
  static Future<void> show(BuildContext context, Movie movie) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => MovieDetailsBottomSheet(movie: movie),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.55,
      maxChildSize: 0.9,
      builder: (_, scrollController) => Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          controller: scrollController,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              movie.title,
              style: theme.textTheme.headlineSmall?.copyWith(
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
                  const Text('  •  '),
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
                  labelStyle: theme.textTheme.labelSmall,
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Text(
              movie.overview,
              style: theme.textTheme.bodyMedium,
            ),
            MovieStreamingProvidersSection(
              movieId: movie.id,
              initialPlatforms: movie.streamingPlatforms,
            ),
          ],
        ),
      ),
    );
  }
}
