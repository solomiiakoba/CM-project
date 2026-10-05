import 'package:flutter/material.dart';
import '../repositories/settings_repository.dart';

class UpdateThemeUseCase {
  final SettingsRepository _repository;

  UpdateThemeUseCase(this._repository);

  Future<void> call(ThemeMode themeMode) => _repository.saveThemeMode(themeMode);
}
