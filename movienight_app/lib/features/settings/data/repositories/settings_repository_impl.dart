import 'package:flutter/material.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _localDataSource;

  SettingsRepositoryImpl(this._localDataSource);

  @override
  Future<AppSettings> getSettings() async {
    final dto = await _localDataSource.getSettings();
    return dto.toEntity();
  }

  @override
  Future<void> saveThemeMode(ThemeMode themeMode) {
    return _localDataSource.saveThemeMode(themeMode);
  }

  @override
  Future<void> saveLocale(Locale locale) {
    return _localDataSource.saveLocale(locale);
  }
}
