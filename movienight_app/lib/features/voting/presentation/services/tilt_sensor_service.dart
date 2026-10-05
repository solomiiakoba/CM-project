import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

import '../providers/voting_state.dart';

class TiltSensorService {
  static const double defaultTiltThreshold = 4.5;
  static const int defaultConfirmWindowMs = 300;

  final double tiltThreshold;
  final int confirmWindowMs;

  StreamSubscription<AccelerometerEvent>? _accelSub;
  Timer? _confirmTimer;
  TiltGesture _pendingGesture = TiltGesture.none;

  void Function(double tiltX, TiltGesture gesture)? onTiltChanged;
  void Function(TiltGesture gesture)? onGestureConfirmed;
  bool Function()? canProcessGesture;

  TiltSensorService({
    this.tiltThreshold = defaultTiltThreshold,
    this.confirmWindowMs = defaultConfirmWindowMs,
    this.onTiltChanged,
    this.onGestureConfirmed,
    this.canProcessGesture,
  });

  void start() {
    stop();
    _accelSub = accelerometerEventStream(
      samplingPeriod: SensorInterval.gameInterval,
    ).listen(_onAccelerometerEvent);
  }

  void _onAccelerometerEvent(AccelerometerEvent event) {
    if (canProcessGesture != null && !canProcessGesture!()) return;

    final x = event.x;
    TiltGesture detected;

    if (x > tiltThreshold) {
      detected = TiltGesture.left;
    } else if (x < -tiltThreshold) {
      detected = TiltGesture.right;
    } else {
      detected = TiltGesture.none;
    }

    onTiltChanged?.call(x, detected);

    if (detected != TiltGesture.none && detected != _pendingGesture) {
      _pendingGesture = detected;
      _confirmTimer?.cancel();
      _confirmTimer = Timer(Duration(milliseconds: confirmWindowMs), () {
        if (canProcessGesture != null && !canProcessGesture!()) return;
        if (_pendingGesture != TiltGesture.none) {
          onGestureConfirmed?.call(_pendingGesture);
        }
      });
    } else if (detected == TiltGesture.none) {
      _pendingGesture = TiltGesture.none;
      _confirmTimer?.cancel();
    }
  }

  void cancelPending() {
    _pendingGesture = TiltGesture.none;
    _confirmTimer?.cancel();
  }

  void stop() {
    _accelSub?.cancel();
    _accelSub = null;
    cancelPending();
  }

  void dispose() {
    stop();
  }
}
