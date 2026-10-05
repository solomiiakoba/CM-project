import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:movienight_app/features/session/data/models/session_dto.dart';

/// Fonte de dados local responsável por persistir e recuperar sessões via SharedPreferences.
class SessionLocalDataSource {
  static const String _activeSessionKey = 'movienight_active_session';
  static const String _sessionKeyPrefix = 'movienight_session_';

  Future<void> saveSession(SessionDto dto) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(dto.toJson());
    await prefs.setString('$_sessionKeyPrefix${dto.id}', jsonStr);
  }

  Future<SessionDto?> getSession(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('$_sessionKeyPrefix$id');
    if (jsonStr == null || jsonStr.isEmpty) return null;

    try {
      final map = jsonDecode(jsonStr);
      if (map is Map<String, dynamic>) {
        return SessionDto.fromJson(map);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> setActiveSession(SessionDto dto) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(dto.toJson());
    await prefs.setString(_activeSessionKey, jsonStr);
    await saveSession(dto);
  }

  Future<SessionDto?> getActiveSession() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_activeSessionKey);
    if (jsonStr == null || jsonStr.isEmpty) return null;

    try {
      final map = jsonDecode(jsonStr);
      if (map is Map<String, dynamic>) {
        return SessionDto.fromJson(map);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> clearActiveSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_activeSessionKey);
  }
}
