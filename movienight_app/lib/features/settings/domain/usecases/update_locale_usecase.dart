import 'package:flutter/material.dart';
import '../repositories/settings_repository.dart';

class UpdateLocaleUseCase {
  final SettingsRepository _repository;

  UpdateLocaleUseCase(this._repository);

  Future<void> call(Locale locale) => _repository.saveLocale(locale);
}
