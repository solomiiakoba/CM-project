import 'dart:math';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Modelo de uma partícula
// ─────────────────────────────────────────────────────────────────────────────

class _Particle {
  double x;      // 0.0 – 1.0 (fracção do ecrã)
  double y;      // 0.0 – 1.0
  double radius;
  double opacity;
  double speedX; // px/s normalizados
  double speedY;
  double pulsePhase; // offset de fase para o efeito de pulso

  _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.opacity,
    required this.speedX,
    required this.speedY,
    required this.pulsePhase,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Widget principal — cola um CustomPainter animado no fundo
// ─────────────────────────────────────────────────────────────────────────────

class ParticleBackground extends StatefulWidget {
  final Widget child;
  final int particleCount;

  const ParticleBackground({
    super.key,
    required this.child,
    this.particleCount = 55,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;
  final Random _rng = Random();

  // Cores foram movidas para o build method e pro painter

  @override
  void initState() {
    super.initState();
    _particles = List.generate(widget.particleCount, (_) => _randomParticle());

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // tick a cada segundo
    )..repeat();
  }

  _Particle _randomParticle({bool startAtTop = false}) {
    return _Particle(
      x: _rng.nextDouble(),
      y: startAtTop ? 1.0 + _rng.nextDouble() * 0.1 : _rng.nextDouble(),
      radius: _rng.nextDouble() * 2.2 + 0.8, // 0.8 – 3.0 px
      opacity: _rng.nextDouble() * 0.5 + 0.15,
      speedX: (_rng.nextDouble() - 0.5) * 0.04, // lento drift horizontal
      speedY: -(_rng.nextDouble() * 0.06 + 0.015), // sobe suavemente
      pulsePhase: _rng.nextDouble() * 2 * pi,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final bgTopColor = isDark ? const Color(0xFF0D0B1E) : const Color(0xFFE2E8F0);
    final bgBottomColor = isDark ? const Color(0xFF0A1628) : const Color(0xFFFFFFFF);

    return Stack(
      fit: StackFit.expand,
      children: [
        // Gradiente de fundo
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [bgTopColor, bgBottomColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        // Camada de partículas
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            // Avança cada partícula
            const double dt = 1 / 60; // ~60fps
            for (final p in _particles) {
              p.x += p.speedX * dt;
              p.y += p.speedY * dt;

              // Wrap horizontal
              if (p.x < -0.05) p.x = 1.05;
              if (p.x > 1.05)  p.x = -0.05;

              // Quando sai pelo topo, renasce na base
              if (p.y < -0.05) {
                p.x = _rng.nextDouble();
                p.y = 1.05;
                p.radius  = _rng.nextDouble() * 2.2 + 0.8;
                p.opacity = _rng.nextDouble() * 0.5 + 0.15;
                p.speedX  = (_rng.nextDouble() - 0.5) * 0.04;
                p.speedY  = -(_rng.nextDouble() * 0.06 + 0.015);
                p.pulsePhase = _rng.nextDouble() * 2 * pi;
              }
            }
            return CustomPaint(
              painter: _ParticlePainter(
                particles: _particles,
                time: _controller.value,
                isDark: isDark,
              ),
            );
          },
        ),

        // Conteúdo da página por cima
        widget.child,
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Painter
// ─────────────────────────────────────────────────────────────────────────────

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double time;
  final bool isDark;

  // Cores das partículas para dark mode
  static const _colorsDark = [
    Color(0xFFB388FF), // violeta claro
    Color(0xFF80DEEA), // ciano
    Color(0xFFFFFFFF), // branco
    Color(0xFF7C4DFF), // roxo
    Color(0xFF40C4FF), // azul céu
  ];

  // Cores das partículas para light mode
  static const _colorsLight = [
    Color(0xFF8B5CF6), // primary
    Color(0xFF06B6D4), // secondary
    Color(0xFF6D28D9), // primaryDark
    Color(0xFF0891B2), // secondaryDark
    Color(0xFF4C1D95), // very dark purple
  ];

  _ParticlePainter({required this.particles, required this.time, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      // Pulso de brilho suave
      final pulse = (sin(time * 2 * pi * 0.5 + p.pulsePhase) * 0.25 + 0.75)
          .clamp(0.0, 1.0);

      final colors = isDark ? _colorsDark : _colorsLight;
      final color = colors[
        (p.x * 100 + p.y * 37).toInt().abs() % colors.length
      ];

      paint.color = color.withValues(alpha: p.opacity * pulse);

      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        p.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => true;
}
