import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../../../app/theme.dart';
import '../../../movies/domain/entities/movie.dart';

/// Cartão do filme em destaque (Filme do Dia) com efeito físico de perspetiva 3D
/// e parallax acoplado aos sensores inerciais do dispositivo.
class HomeSpotlightParallaxCard extends StatefulWidget {
  final Movie movie;
  final VoidCallback onTap;

  const HomeSpotlightParallaxCard({
    super.key,
    required this.movie,
    required this.onTap,
  });

  @override
  State<HomeSpotlightParallaxCard> createState() =>
      _HomeSpotlightParallaxCardState();
}

class _HomeSpotlightParallaxCardState extends State<HomeSpotlightParallaxCard> {
  StreamSubscription<AccelerometerEvent>? _sensorSub;

  double _smoothTiltX = 0.0;
  static const double _filter = 0.84;

  @override
  void initState() {
    super.initState();
    _startMotionTracking();
  }

  void _startMotionTracking() {
    _sensorSub = accelerometerEventStream(
      samplingPeriod: SensorInterval.gameInterval,
    ).listen((event) {
      if (!mounted) return;
      // Normalização da inclinação lateral (-9.8 a +9.8 m/s²)
      final rawTilt = (event.x / 9.8).clamp(-1.0, 1.0);
      _smoothTiltX = _filter * _smoothTiltX + (1 - _filter) * rawTilt;

      setState(() {});
    });
  }

  @override
  void dispose() {
    _sensorSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Rotação suave no eixo Y em radianos (inversão natural de perspetiva)
    final rotationY = -_smoothTiltX * 0.14;
    // Translação lateral subtil para profundidade parallax
    final translationX = -_smoothTiltX * 8.0;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: widget.onTap,
      child: Transform(
        alignment: FractionalOffset.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.0015)
          ..translate(translationX)
          ..rotateY(rotationY),
        child: Container(
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: MNColors.primary.withValues(alpha: isDark ? 0.3 : 0.18),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.12),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ── Poster do Filme em Destaque ──────────────────────
                if (widget.movie.posterPath != null &&
                    widget.movie.posterPath!.isNotEmpty)
                  Image.network(
                    widget.movie.posterPath!,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    errorBuilder: (_, __, ___) => _buildPlaceholder(context),
                  )
                else
                  _buildPlaceholder(context),

                // ── Gradiente Cinematográfico para Legibilidade ─────
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.2),
                        Colors.black.withValues(alpha: 0.55),
                        Colors.black.withValues(alpha: 0.92),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),

                // ── Badge Superior: Filme do Dia ─────────────────────
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFFFD700).withValues(alpha: 0.6),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_fire_department_rounded,
                          color: Color(0xFFFFD700),
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'FILME DO DIA',
                          style: TextStyle(
                            color: Color(0xFFFFD700),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Conteúdo Inferior: Título, Nota e Géneros ────────
                Positioned(
                  bottom: 14,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.movie.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD700)
                                  .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFFFD700)
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Color(0xFFFFD700),
                                  size: 13,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  widget.movie.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${widget.movie.releaseYear}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (widget.movie.genres.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.movie.genres.take(2).join(' • '),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: cs.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.movie_rounded,
          color: cs.onSurfaceVariant.withValues(alpha: 0.35),
          size: 64,
        ),
      ),
    );
  }
}
