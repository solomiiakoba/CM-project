import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../movies/domain/entities/movie.dart';
import '../providers/voting_state.dart';
import 'vote_gesture_overlay.dart';

class MovieVoteCard extends StatelessWidget {
  final Movie movie;
  final TiltGesture gesture;

  const MovieVoteCard({
    super.key,
    required this.movie,
    required this.gesture,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isLike = gesture == TiltGesture.right;
    final isSkip = gesture == TiltGesture.left;

    final borderColor = isLike
        ? const Color(0xFF22C55E).withValues(alpha: 0.6)
        : isSkip
            ? const Color(0xFFEF4444).withValues(alpha: 0.6)
            : cs.outlineVariant;

    final shadowColor = isLike
        ? const Color(0xFF22C55E).withValues(alpha: 0.2)
        : isSkip
            ? const Color(0xFFEF4444).withValues(alpha: 0.2)
            : Colors.black.withValues(alpha: isDark ? 0.25 : 0.08);

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: borderColor,
          width: gesture != TiltGesture.none ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _PosterBackground(posterPath: movie.posterPath),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    (isDark ? MNColors.background : const Color(0xFF0F172A))
                        .withValues(alpha: 0.92),
                  ],
                  stops: const [0.35, 1.0],
                ),
              ),
            ),
          ),
          if (isLike)
            const VoteGestureOverlay(
              label: 'LIKE',
              icon: Icons.favorite_rounded,
              color: Color(0xFF22C55E),
              alignment: Alignment.topLeft,
            ),
          if (isSkip)
            const VoteGestureOverlay(
              label: 'SKIP',
              icon: Icons.close_rounded,
              color: Color(0xFFEF4444),
              alignment: Alignment.topRight,
            ),
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
                          colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
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
                      const Text(
                        '  ·  ',
                        style: TextStyle(color: Colors.white38, fontSize: 13),
                      ),
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
                  children: movie.genres.take(3).map((genre) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        genre,
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
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.4,
                  ),
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
        errorBuilder: (_, _, _) => _placeholder(context),
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
        child: Icon(
          Icons.movie_outlined,
          size: 72,
          color: cs.onPrimaryContainer,
        ),
      ),
    );
  }
}
