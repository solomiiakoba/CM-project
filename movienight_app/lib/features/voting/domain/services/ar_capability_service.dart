/// Contrato de serviço do domínio para verificar capacidades e permissões de Realidade Aumentada.
abstract class ArCapabilityService {
  /// Retorna true se o dispositivo suporta rastreio AR nativo ou modo compatível de câmara.
  Future<bool> isArSupported();

  /// Retorna true se a aplicação possui permissão para utilizar a câmara no modo AR.
  Future<bool> hasCameraPermission();
}
