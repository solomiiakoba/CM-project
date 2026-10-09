import 'package:flutter/material.dart';

import '../../domain/entities/ar_trophy_config.dart';
import '../services/ar_spatial_motion_service.dart';
import '../widgets/ar/ar_camera_viewfinder.dart';
import '../widgets/ar/ar_plane_reticle.dart';
import '../widgets/ar/ar_trophy_hud_overlay.dart';
import '../widgets/ar/ar_trophy_pedestal_card.dart';

/// Ecrã de Realidade Aumentada para projeção do troféu do filme vencedor no espaço físico.
class ArWinnerPage extends StatefulWidget {
  final ArTrophyConfig config;

  const ArWinnerPage({
    super.key,
    required this.config,
  });

  @override
  State<ArWinnerPage> createState() => _ArWinnerPageState();
}

class _ArWinnerPageState extends State<ArWinnerPage>
    with SingleTickerProviderStateMixin {
  bool _isAnchored = false;
  bool _isAutoRotating = false;
  bool _isMotionSensorActive = true;
  bool _isStudioMode = false;

  double _rotationY = 0.0;
  double _rotationX = 0.0;

  late final AnimationController _autoRotateController;
  late final ArSpatialMotionService _motionService;

  @override
  void initState() {
    super.initState();

    _autoRotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..addListener(() {
        if (_isAutoRotating) {
          setState(() {
            _rotationY = _autoRotateController.value * 2 * 3.14159;
          });
        }
      });

    _motionService = ArSpatialMotionService(
      onMotionUpdate: _onMotionUpdate,
    );
    _motionService.start();
  }

  void _onMotionUpdate(double roll, double pitch, double yaw) {
    if (_isMotionSensorActive && !_isAutoRotating && mounted) {
      setState(() {
        _rotationX = pitch;
        _rotationY = roll + yaw;
      });
    }
  }

  @override
  void dispose() {
    _motionService.stop();
    _autoRotateController.dispose();
    super.dispose();
  }

  void _handlePanUpdate(double dx, double dy) {
    if (_isAutoRotating) {
      _toggleAutoRotate();
    }
    if (_isMotionSensorActive) {
      setState(() {
        _isMotionSensorActive = false;
      });
    }

    setState(() {
      _rotationY += dx * 0.015;
      _rotationX = (_rotationX - dy * 0.01).clamp(-0.4, 0.4);
    });
  }

  void _toggleAnchor() {
    setState(() {
      _isAnchored = !_isAnchored;
      if (_isAnchored) {
        _motionService.resetYaw();
      }
    });
  }

  void _toggleAutoRotate() {
    setState(() {
      _isAutoRotating = !_isAutoRotating;
      if (_isAutoRotating) {
        _isMotionSensorActive = false;
        _autoRotateController.repeat();
      } else {
        _autoRotateController.stop();
      }
    });
  }

  void _toggleMotionSensor() {
    setState(() {
      _isMotionSensorActive = !_isMotionSensorActive;
      if (_isMotionSensorActive) {
        _isAutoRotating = false;
        _autoRotateController.stop();
        _motionService.resetYaw();
      }
    });
  }

  void _toggleStudioMode() {
    setState(() {
      _isStudioMode = !_isStudioMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Fundo: Visão da Câmara em Tempo Real ou Estúdio Holográfico ──
          ArCameraViewfinder(isStudioMode: _isStudioMode),

          // ── Camada Intermédia: Retículo ou Troféu 3D ───────────────
          if (!_isAnchored)
            ArPlaneReticle(onTap: _toggleAnchor)
          else
            ArTrophyPedestalCard(
              config: widget.config,
              rotationY: _rotationY,
              rotationX: _rotationX,
              onPanUpdate: _handlePanUpdate,
            ),

          // ── Camada Superior: HUD de Navegação e Controlos ──────────
          ArTrophyHudOverlay(
            isAnchored: _isAnchored,
            isAutoRotating: _isAutoRotating,
            isMotionSensorActive: _isMotionSensorActive,
            isStudioMode: _isStudioMode,
            onBack: () => Navigator.pop(context),
            onToggleAnchor: _toggleAnchor,
            onToggleAutoRotate: _toggleAutoRotate,
            onToggleMotionSensor: _toggleMotionSensor,
            onToggleStudioMode: _toggleStudioMode,
          ),
        ],
      ),
    );
  }
}
