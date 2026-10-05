import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/voting_session_dto.dart';

abstract class VotingLocalDataSource {
  Future<void> saveVotingSession(VotingSessionDto sessionDto);
  Future<VotingSessionDto?> loadVotingSession(String sessionId);
  Future<void> clearVotingSession(String sessionId);
}

class VotingLocalDataSourceImpl implements VotingLocalDataSource {
  static const String _prefix = 'movienight_voting_';

  final SharedPreferences? _prefsInstance;

  VotingLocalDataSourceImpl({SharedPreferences? prefs})
      : _prefsInstance = prefs;

  Future<SharedPreferences> get _prefs async =>
      _prefsInstance ?? await SharedPreferences.getInstance();

  String _key(String sessionId) => '$_prefix$sessionId';

  @override
  Future<void> saveVotingSession(VotingSessionDto sessionDto) async {
    final prefs = await _prefs;
    final encoded = jsonEncode(sessionDto.toJson());
    await prefs.setString(_key(sessionDto.sessionId), encoded);
  }

  @override
  Future<VotingSessionDto?> loadVotingSession(String sessionId) async {
    final prefs = await _prefs;
    final encoded = prefs.getString(_key(sessionId));
    if (encoded == null) return null;

    try {
      final decoded = jsonDecode(encoded) as Map<String, dynamic>;
      return VotingSessionDto.fromJson(decoded);
    } catch (_) {
      await prefs.remove(_key(sessionId));
      return null;
    }
  }

  @override
  Future<void> clearVotingSession(String sessionId) async {
    final prefs = await _prefs;
    await prefs.remove(_key(sessionId));
  }
}
