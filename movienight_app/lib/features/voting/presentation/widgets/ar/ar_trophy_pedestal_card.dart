import 'package:flutter/material.dart';
import 'package:movienight_app/features/voting/domain/entities/ar_trophy_config.dart';

/// Renderiza o troféu tridimensional holográfico do filme vencedor ancorado no espaço virtual.
class ArTrophyPedestalCard extends StatelessWidget {
  final ArTrophyConfig config;
  final double rotationY;
  final double rotationX;
  final Function(double dx, double dy) onPanUpdate;

  const ArTrophyPedestalCard({
    super.key,
    required this.config,
    required this.rotationY,
    required this.rotationX,
    required this.onPanUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) => onPanUpdate(details.delta.dx, details.delta.dy),
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Troféu Tridimensional com Perspetiva Matrix4 ──────────
            Transform(
              alignment: FractionalOffset.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.002) // perspetiva 3D
                ..rotateX(rotationX)
                ..rotateY(rotationY),
              child: _buildTrophyBody(context),
            ),

            const SizedBox(height: 16),

            // ── Sombra de Ancoragem Projetada na Superfície ───────────
            Container(
              width: 180,
              height: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.65),
                    blurRadius: 28,
                    spreadRadius: 6,
                  ),
                  BoxShadow(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.25),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrophyBody(BuildContext context) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: const Color(0xFF141722),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFFD700).withValues(alpha: 0.85),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withValues(alpha: 0.35),
            blurRadius: 30,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Cabeçalho do Troféu com Fita Dourada ───────────────
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFD4AF37),
                    Color(0xFFFFDF73),
                    Color(0xFFB8860B),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.emoji_events_outlined,
                    color: Color(0xFF221A00),
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      config.celebrationMessage.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF221A00),
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Poster do Filme Vencedor ─────────────────────────
            SizedBox(
              height: 250,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (config.posterPath != null && config.posterPath!.isNotEmpty)
                    Image.network(
                      config.posterPath!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _buildPlaceholderPoster(),
                    )
                  else
                    _buildPlaceholderPoster(),

                  // Gradiente inferior para legibilidade
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 80,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.85),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Badges flutuantes no poster
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFFD700).withValues(alpha: 0.6),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 14),
                          const SizedBox(width: 3),
                          Text(
                            config.formattedRating,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
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

            // ── Placa de Base / Pedestal com Título e Estatísticas ──
            Container(
              padding: const EdgeInsets.all(12),
              color: const Color(0xFF10131E),
              child: Column(
                children: [
                  Text(
                    config.movieTitle,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2436),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Text(
                      '${config.affirmativeVotes} votos afirmativos (${config.winPercentage.toStringAsFixed(0)}%)',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _buildPlaceholderPoster() {
    return Container(
      color: const Color(0xFF1E2230),
      child: const Center(
        child: Icon(
          Icons.movie_filter_outlined,
          color: Colors.white24,
          size: 64,
        ),
      ),
    );
  }
}
