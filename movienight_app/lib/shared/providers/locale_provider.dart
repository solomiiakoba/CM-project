import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/presentation/providers/settings_providers.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return LocaleNotifier(repository);
});

class LocaleNotifier extends StateNotifier<Locale> {
  final SettingsRepository _repository;

  LocaleNotifier(this._repository) : super(const Locale('pt')) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final settings = await _repository.getSettings();
    state = settings.locale;
  }

  Future<void> setLocale(Locale locale) async {
    if (!['en', 'pt'].contains(locale.languageCode)) return;
    
    state = locale;
    await _repository.saveLocale(locale);
  }
}
