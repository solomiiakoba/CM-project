import 'package:flutter/material.dart';

import '../../../movies/domain/entities/movie.dart';
import '../../../../shared/widgets/glass_container.dart';

class ResultsRankingRow extends StatelessWidget {
  final int position;
  final Movie movie;
  final int likes;
  final int maxLikes;
  final String likesFormatted;

  const ResultsRankingRow({
    super.key,
    required this.position,
    required this.movie,
    required this.likes,
    required this.maxLikes,
    required this.likesFormatted,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      borderRadius: 16,
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              '#$position',
              style: TextStyle(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 44,
            height: 58,
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.antiAlias,
            child: movie.posterPath != null &&
                    movie.posterPath!.startsWith('http')
                ? Image.network(movie.posterPath!, fit: BoxFit.cover)
                : Icon(Icons.movie_outlined, color: cs.onPrimaryContainer),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${movie.releaseYear}',
                  style: TextStyle(
                    color: cs.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.favorite_rounded,
                    color: Color(0xFFEF4444),
                    size: 13,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    likesFormatted,
                    style: TextStyle(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: maxLikes > 0 ? likes / maxLikes : 0,
                    minHeight: 5,
                    backgroundColor: cs.outlineVariant,
                    valueColor: AlwaysStoppedAnimation(cs.primary),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
