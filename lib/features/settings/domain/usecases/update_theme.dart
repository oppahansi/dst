// Flutter Imports
import 'package:flutter/material.dart';

// Project Imports
import 'package:sdtpro/features/settings/domain/repos/settings_repository.dart';

class UpdateTheme {
  final SettingsRepository repository;

  UpdateTheme(this.repository);

  Future<void> call(ThemeMode themeMode) =>
      repository.updateThemeMode(themeMode);
}
