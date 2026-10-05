import 'package:flutter/material.dart';

class AppSettings {
  final ThemeMode themeMode;
  final Locale locale;

  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.locale = const Locale('pt'),
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    Locale? locale,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettings &&
          runtimeType == other.runtimeType &&
          themeMode == other.themeMode &&
          locale == other.locale;

  @override
  int get hashCode => themeMode.hashCode ^ locale.hashCode;
}
