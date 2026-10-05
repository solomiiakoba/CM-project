import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/settings_local_datasource.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../domain/usecases/update_locale_usecase.dart';
import '../../domain/usecases/update_theme_usecase.dart';

final settingsLocalDataSourceProvider = Provider<SettingsLocalDataSource>((ref) {
  return SettingsLocalDataSourceImpl();
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final dataSource = ref.watch(settingsLocalDataSourceProvider);
  return SettingsRepositoryImpl(dataSource);
});

final getSettingsUseCaseProvider = Provider<GetSettingsUseCase>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return GetSettingsUseCase(repository);
});

final updateThemeUseCaseProvider = Provider<UpdateThemeUseCase>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return UpdateThemeUseCase(repository);
});

final updateLocaleUseCaseProvider = Provider<UpdateLocaleUseCase>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return UpdateLocaleUseCase(repository);
});

final appSettingsProvider = StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  final getSettings = ref.watch(getSettingsUseCaseProvider);
  final updateTheme = ref.watch(updateThemeUseCaseProvider);
  final updateLocale = ref.watch(updateLocaleUseCaseProvider);
  return AppSettingsNotifier(
    getSettingsUseCase: getSettings,
    updateThemeUseCase: updateTheme,
    updateLocaleUseCase: updateLocale,
  );
});

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  final GetSettingsUseCase _getSettingsUseCase;
  final UpdateThemeUseCase _updateThemeUseCase;
  final UpdateLocaleUseCase _updateLocaleUseCase;

  AppSettingsNotifier({
    required GetSettingsUseCase getSettingsUseCase,
    required UpdateThemeUseCase updateThemeUseCase,
    required UpdateLocaleUseCase updateLocaleUseCase,
  })  : _getSettingsUseCase = getSettingsUseCase,
        _updateThemeUseCase = updateThemeUseCase,
        _updateLocaleUseCase = updateLocaleUseCase,
        super(const AppSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _getSettingsUseCase();
    state = settings;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _updateThemeUseCase(mode);
  }

  Future<void> setLocale(Locale locale) async {
    if (!['en', 'pt'].contains(locale.languageCode)) return;
    state = state.copyWith(locale: locale);
    await _updateLocaleUseCase(locale);
  }
}
