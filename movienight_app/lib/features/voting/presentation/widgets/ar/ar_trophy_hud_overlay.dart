import 'package:flutter/material.dart';

import 'package:movienight_app/shared/widgets/glass_back_button.dart';

/// Barra de ferramentas e HUD para controlo da experiência de Realidade Aumentada.
class ArTrophyHudOverlay extends StatelessWidget {
  final bool isAnchored;
  final bool isAutoRotating;
  final bool isMotionSensorActive;
  final bool isStudioMode;
  final VoidCallback onBack;
  final VoidCallback onToggleAnchor;
  final VoidCallback onToggleAutoRotate;
  final VoidCallback onToggleMotionSensor;
  final VoidCallback onToggleStudioMode;

  const ArTrophyHudOverlay({
    super.key,
    required this.isAnchored,
    required this.isAutoRotating,
    required this.isMotionSensorActive,
    required this.isStudioMode,
    required this.onBack,
    required this.onToggleAnchor,
    required this.onToggleAutoRotate,
    required this.onToggleMotionSensor,
    required this.onToggleStudioMode,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ── Barra Superior (Top HUD) ───────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GlassBackButton(
                    onPressed: onBack,
                    iconColor: Colors.white,
                    backgroundColor: Colors.black.withValues(alpha: 0.6),
                    borderColor: Colors.white24,
                    iconSize: 18,
                  ),

                  // Status Chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isAnchored
                            ? const Color(0xFFFFD700).withValues(alpha: 0.7)
                            : Colors.white24,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isAnchored
                              ? Icons.check_circle_rounded
                              : Icons.radar_rounded,
                          color: isAnchored
                              ? const Color(0xFFFFD700)
                              : Colors.amberAccent,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isAnchored ? 'Troféu Ancorado' : 'A Procurar Superfície',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Botão Alternar Câmara / Fundo Estúdio
                  IconButton(
                    onPressed: onToggleStudioMode,
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isStudioMode
                            ? const Color(0xFF6366F1).withValues(alpha: 0.4)
                            : Colors.black.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isStudioMode
                              ? const Color(0xFF6366F1)
                              : Colors.white24,
                        ),
                      ),
                      child: Icon(
                        isStudioMode
                            ? Icons.videocam_rounded
                            : Icons.videocam_off_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),

              // ── Barra Inferior (Bottom HUD Controls) ───────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isAnchored) ...[
                    // Botão Sensor IMU (Giroscópio / Acelerómetro)
                    IconButton(
                      onPressed: onToggleMotionSensor,
                      tooltip: isMotionSensorActive
                          ? 'Modo Giroscópio Ativo'
                          : 'Modo Manual Ativo',
                      icon: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMotionSensorActive
                              ? const Color(0xFFFFD700).withValues(alpha: 0.3)
                              : Colors.black.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isMotionSensorActive
                                ? const Color(0xFFFFD700)
                                : Colors.white24,
                          ),
                        ),
                        child: Icon(
                          Icons.screen_rotation_rounded,
                          color: isMotionSensorActive
                              ? const Color(0xFFFFD700)
                              : Colors.white70,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Botão de Auto-Rotação
                    IconButton(
                      onPressed: onToggleAutoRotate,
                      tooltip: 'Rotação Contínua 360',
                      icon: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isAutoRotating
                              ? const Color(0xFFFFD700).withValues(alpha: 0.3)
                              : Colors.black.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isAutoRotating
                                ? const Color(0xFFFFD700)
                                : Colors.white24,
                          ),
                        ),
                        child: Icon(
                          Icons.rotate_right_rounded,
                          color: isAutoRotating
                              ? const Color(0xFFFFD700)
                              : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],

                  // Botão Primário: Fixar / Reposicionar
                  ElevatedButton.icon(
                    onPressed: onToggleAnchor,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isAnchored
                          ? const Color(0xFF1E2436)
                          : const Color(0xFFFFD700),
                      foregroundColor: isAnchored
                          ? Colors.white
                          : const Color(0xFF221A00),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(
                          color: isAnchored ? Colors.white24 : Colors.transparent,
                        ),
                      ),
                      elevation: 4,
                    ),
                    icon: Icon(
                      isAnchored ? Icons.tune_rounded : Icons.place_rounded,
                      size: 18,
                    ),
                    label: Text(
                      isAnchored ? 'Reposicionar' : 'Fixar Aqui',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
