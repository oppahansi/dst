// Flutter Imports
import 'package:flutter/material.dart';

// Project Imports
import 'package:sdtpro/features/settings/domain/repos/settings_repository.dart';

class UpdateLocale {
  final SettingsRepository repository;

  UpdateLocale(this.repository);

  Future<void> call(Locale locale) => repository.updateLocale(locale);
}
