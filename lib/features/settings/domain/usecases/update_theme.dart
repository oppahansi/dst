// Flutter Imports
import 'package:flutter/material.dart';

// Project Imports
import 'package:sdt/features/settings/domain/repos/settings_repo.dart';

class UpdateTheme {
  final SettingsRepo repository;

  UpdateTheme(this.repository);

  Future<void> call(ThemeMode themeMode) =>
      repository.updateThemeMode(themeMode);
}
