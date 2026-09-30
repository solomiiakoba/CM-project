import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:movienight_app/features/voting/domain/entities/vote.dart';
import 'package:movienight_app/features/voting/domain/entities/voting_session.dart';
import 'package:movienight_app/features/voting/domain/repositories/voting_repository.dart';

class VotingRepositoryImpl implements VotingRepository {
  static const String _prefix = 'movienight_voting_';

  String _key(String sessionId) => '$_prefix$sessionId';

  @override
  Future<void> saveVotingSession(VotingSession session) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(session.toJson());
    await prefs.setString(_key(session.sessionId), encoded);
  }

  @override
  Future<VotingSession?> loadVotingSession(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString(_key(sessionId));
    if (encoded == null) return null;
    try {
      return VotingSession.fromJson(
        jsonDecode(encoded) as Map<String, dynamic>,
      );
    } catch (_) {
      await prefs.remove(_key(sessionId));
      return null;
    }
  }

  @override
  Future<VotingSession> castVote({
    required String sessionId,
    required Vote vote,
  }) async {
    final existing = await loadVotingSession(sessionId);
    if (existing == null) {
      throw StateError('VotingSession $sessionId not found');
    }
    final updated = existing.addVote(vote);
    await saveVotingSession(updated);
    return updated;
  }

  @override
  Future<void> clearVotingSession(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(sessionId));
  }
}
