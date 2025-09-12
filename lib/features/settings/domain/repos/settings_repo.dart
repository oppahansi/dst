// Package Imports
import "package:flutter/material.dart";

// Project Imports
import "package:sdtpro/features/settings/domain/entities/settings.dart";

abstract class SettingsRepo {
  Future<Settings> getSettings();
  Future<void> updateThemeMode(ThemeMode themeMode);
  Future<void> updateLocale(Locale locale);
}
