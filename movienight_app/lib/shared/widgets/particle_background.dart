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

  // Gradiente de fundo — roxo/azul profundo
  static const _bgTopColor    = Color(0xFF0D0B1E); // quase preto violeta
  static const _bgBottomColor = Color(0xFF0A1628); // azul petróleo profundo

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
    return Stack(
      fit: StackFit.expand,
      children: [
        // Gradiente de fundo
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_bgTopColor, _bgBottomColor],
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

  // Cores das partículas (lilás / ciano / branco)
  static const _colors = [
    Color(0xFFB388FF), // violeta claro
    Color(0xFF80DEEA), // ciano
    Color(0xFFFFFFFF), // branco
    Color(0xFF7C4DFF), // roxo
    Color(0xFF40C4FF), // azul céu
  ];

  _ParticlePainter({required this.particles, required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      // Pulso de brilho suave
      final pulse = (sin(time * 2 * pi * 0.5 + p.pulsePhase) * 0.25 + 0.75)
          .clamp(0.0, 1.0);

      final color = _colors[
        (p.x * 100 + p.y * 37).toInt().abs() % _colors.length
      ];

      paint.color = color.withOpacity(p.opacity * pulse);

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
