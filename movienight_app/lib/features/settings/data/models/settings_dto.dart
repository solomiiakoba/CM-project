import 'package:flutter/material.dart';
import '../../domain/entities/app_settings.dart';

class SettingsDto {
  final String? themeMode;
  final String? languageCode;

  const SettingsDto({
    this.themeMode,
    this.languageCode,
  });

  factory SettingsDto.fromJson(Map<String, dynamic> json) {
    return SettingsDto(
      themeMode: json['theme_mode'] as String?,
      languageCode: json['language_code'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'theme_mode': themeMode,
      'language_code': languageCode,
    };
  }

  AppSettings toEntity() {
    ThemeMode resolvedTheme = ThemeMode.system;
    if (themeMode == 'dark') {
      resolvedTheme = ThemeMode.dark;
    } else if (themeMode == 'light') {
      resolvedTheme = ThemeMode.light;
    }

    final resolvedLocale = (languageCode != null && (languageCode == 'en' || languageCode == 'pt'))
        ? Locale(languageCode!)
        : const Locale('pt');

    return AppSettings(
      themeMode: resolvedTheme,
      locale: resolvedLocale,
    );
  }

  static String themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.system:
        return 'system';
    }
  }
}
