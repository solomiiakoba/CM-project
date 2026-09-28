import 'package:shared_preferences/shared_preferences.dart';

class ParticipantIdentityService {
  static const String _participantIdKey = 'participant_id';

  Future<String> getParticipantId() async {
    final prefs = await SharedPreferences.getInstance();

    final existingId = prefs.getString(_participantIdKey);

    if (existingId != null && existingId.isNotEmpty) {
      return existingId;
    }

    final newId =
        'device-${DateTime.now().millisecondsSinceEpoch}';

    await prefs.setString(_participantIdKey, newId);

    return newId;
  }
}
