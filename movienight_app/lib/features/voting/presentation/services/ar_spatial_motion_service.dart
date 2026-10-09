import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

/// Serviço responsável pelo processamento de orientação espacial 3D
/// através da fusão de dados do acelerómetro e giroscópio do dispositivo.
class ArSpatialMotionService {
  StreamSubscription<AccelerometerEvent>? _accelSub;
  StreamSubscription<GyroscopeEvent>? _gyroSub;

  double _smoothRoll = 0.0;
  double _smoothPitch = 0.0;
  double _yaw = 0.0;

  static const double _filterFactor = 0.82;

  void Function(double roll, double pitch, double yaw)? onMotionUpdate;

  ArSpatialMotionService({this.onMotionUpdate});

  void start() {
    stop();

    _accelSub = accelerometerEventStream(
      samplingPeriod: SensorInterval.gameInterval,
    ).listen((event) {
      // Normalização do vetor de gravidade para Roll (X) e Pitch (Y/Z)
      final rawRoll = (event.x / 9.8).clamp(-1.0, 1.0) * 0.45;
      final rawPitch = ((event.z / 9.8) - 1.0).clamp(-1.0, 1.0) * 0.35;

      // Filtro passa-baixo para eliminar tremor muscular (jitter)
      _smoothRoll = _filterFactor * _smoothRoll + (1 - _filterFactor) * rawRoll;
      _smoothPitch = _filterFactor * _smoothPitch + (1 - _filterFactor) * rawPitch;

      onMotionUpdate?.call(_smoothRoll, _smoothPitch, _yaw);
    });

    _gyroSub = gyroscopeEventStream(
      samplingPeriod: SensorInterval.gameInterval,
    ).listen((event) {
      // Integração angular do eixo Z (Yaw)
      _yaw += event.z * 0.015;
      onMotionUpdate?.call(_smoothRoll, _smoothPitch, _yaw);
    });
  }

  void stop() {
    _accelSub?.cancel();
    _accelSub = null;
    _gyroSub?.cancel();
    _gyroSub = null;
  }

  void resetYaw() {
    _yaw = 0.0;
  }
}
