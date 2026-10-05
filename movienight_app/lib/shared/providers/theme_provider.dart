import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/presentation/providers/settings_providers.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return ThemeNotifier(repository);
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final SettingsRepository _repository;

  ThemeNotifier(this._repository) : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final settings = await _repository.getSettings();
    state = settings.themeMode;
  }

  Future<void> toggleTheme(bool isDark) async {
    final mode = isDark ? ThemeMode.dark : ThemeMode.light;
    state = mode;
    await _repository.saveThemeMode(mode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _repository.saveThemeMode(mode);
  }
}
