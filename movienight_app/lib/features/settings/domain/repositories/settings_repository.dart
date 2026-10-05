import 'package:flutter/material.dart';
import '../entities/app_settings.dart';

abstract class SettingsRepository {
  Future<AppSettings> getSettings();
  Future<void> saveThemeMode(ThemeMode themeMode);
  Future<void> saveLocale(Locale locale);
}
