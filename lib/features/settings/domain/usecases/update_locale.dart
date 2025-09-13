// Flutter Imports
import 'package:flutter/material.dart';

// Project Imports
import 'package:sdt/features/settings/domain/repos/settings_repo.dart';

class UpdateLocale {
  final SettingsRepo repository;

  UpdateLocale(this.repository);

  Future<void> call(Locale locale) => repository.updateLocale(locale);
}
