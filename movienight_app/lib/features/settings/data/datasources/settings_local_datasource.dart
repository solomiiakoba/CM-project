import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings_dto.dart';

abstract class SettingsLocalDataSource {
  Future<SettingsDto> getSettings();
  Future<void> saveThemeMode(ThemeMode themeMode);
  Future<void> saveLocale(Locale locale);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const String themeKey = 'app_theme_mode';
  static const String languageKey = 'app_language_code';

  final SharedPreferences? _prefsInstance;

  SettingsLocalDataSourceImpl({SharedPreferences? prefs}) : _prefsInstance = prefs;

  Future<SharedPreferences> get _prefs async =>
      _prefsInstance ?? await SharedPreferences.getInstance();

  @override
  Future<SettingsDto> getSettings() async {
    final prefs = await _prefs;
    final themeVal = prefs.get(themeKey);
    String? themeStr;
    if (themeVal is bool) {
      themeStr = themeVal ? 'dark' : 'light';
    } else if (themeVal is String) {
      themeStr = themeVal;
    }

    final langCode = prefs.getString(languageKey);

    return SettingsDto(
      themeMode: themeStr,
      languageCode: langCode,
    );
  }

  @override
  Future<void> saveThemeMode(ThemeMode themeMode) async {
    final prefs = await _prefs;
    if (themeMode == ThemeMode.system) {
      await prefs.remove(themeKey);
    } else {
      await prefs.setBool(themeKey, themeMode == ThemeMode.dark);
    }
  }

  @override
  Future<void> saveLocale(Locale locale) async {
    final prefs = await _prefs;
    await prefs.setString(languageKey, locale.languageCode);
  }
}
