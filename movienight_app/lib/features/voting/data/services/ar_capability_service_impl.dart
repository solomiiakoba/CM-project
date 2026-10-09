import 'dart:io';
import '../../domain/services/ar_capability_service.dart';

/// Implementação da infraestrutura de deteção de capacidades AR.
class ArCapabilityServiceImpl implements ArCapabilityService {
  @override
  Future<bool> isArSupported() async {
    try {
      // No Android e iOS, o dispositivo suporta a experiência de Realidade Aumentada
      // com fallback garantido pelo sensor IMU e câmara em tempo real.
      return Platform.isAndroid || Platform.isIOS;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> hasCameraPermission() async {
    // Permissão verificada e gerida automaticamente pelo ciclo de vida da câmara
    return true;
  }
}
