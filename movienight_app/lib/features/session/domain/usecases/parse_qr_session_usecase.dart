import 'dart:convert';

import 'package:movienight_app/features/session/domain/entities/session.dart';
import 'package:movienight_app/features/session/domain/exceptions/session_exceptions.dart';

/// Caso de uso que analisa e valida o payload ótico (QR Code) de convite para uma sessão.
class ParseQrSessionUseCase {
  const ParseQrSessionUseCase();

  Session execute(String rawQrData) {
    if (rawQrData.trim().isEmpty) {
      throw const InvalidSessionQrException('Código QR vazio.');
    }

    try {
      final decoded = jsonDecode(rawQrData);
      if (decoded is! Map) {
        throw const InvalidSessionQrException('Formato do código QR não é um objeto JSON válido.');
      }

      final type = decoded['type']?.toString();
      if (type != 'session_invite') {
        throw const InvalidSessionQrException('O código QR lido não é um convite de sessão MovieNight.');
      }

      final normalized = Map<String, dynamic>.from(decoded);
      // Suporta tanto sessionId como id
      final sessionId = normalized['sessionId'] ?? normalized['id'];
      if (sessionId == null || sessionId.toString().trim().isEmpty) {
        throw const InvalidSessionQrException('Código QR não contém um identificador de sessão válido.');
      }
      normalized['id'] = sessionId.toString();

      if (normalized['name'] == null || normalized['name'].toString().trim().isEmpty) {
        normalized['name'] = 'Movie Night';
      }

      if (normalized['createdAt'] == null) {
        normalized['createdAt'] = DateTime.now().toIso8601String();
      }

      if (normalized['organizerId'] == null) {
        normalized['organizerId'] = 'unknown';
      }

      return Session.fromJson(normalized);
    } on SessionException {
      rethrow;
    } catch (e) {
      throw InvalidSessionQrException('Erro ao processar dados do código QR: $e');
    }
  }
}
