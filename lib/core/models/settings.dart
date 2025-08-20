// Flutter Imports
import "package:flutter/material.dart";

// Project Imports
import "package:oppa_app/core/utils/constants.dart";

class Settings {
  final ThemeMode themeMode;
  final Locale locale;

  Settings({required this.themeMode, required this.locale});

  factory Settings.defaultSettings() {
    return Settings(
      themeMode: ThemeMode.system,
      locale: const Locale(settingsValueLocaleDefault),
    );
  }
}
