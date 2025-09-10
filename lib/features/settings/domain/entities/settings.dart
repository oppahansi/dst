// Package Imports
import "package:flutter/material.dart";

// Project Imports
import "package:sdtpro/core/utils/constants.dart";

class Settings {
  final ThemeMode themeMode;
  final Locale locale;

  Settings({required this.themeMode, required this.locale});

  Settings copyWith({ThemeMode? themeMode, Locale? locale}) {
    return Settings(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }

  factory Settings.defaultSettings() {
    return Settings(
      themeMode: ThemeMode.system,
      locale: const Locale(settingsValueLocaleDefault),
    );
  }
}
