// Package Imports
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project Imports
import 'package:sdtpro/features/settings/data/settings_repository_impl.dart';
import 'package:sdtpro/features/settings/domain/repos/settings_repository.dart';
import 'package:sdtpro/features/settings/domain/usecases/get_settings.dart';
import 'package:sdtpro/features/settings/domain/usecases/update_locale.dart';
import 'package:sdtpro/features/settings/domain/usecases/update_theme.dart';

part 'settings_usecase_providers.g.dart';

/// Provides the concrete implementation of the SettingsRepository.
/// In a real app, you might switch this out for a mock repository during tests.
@riverpod
SettingsRepository settingsRepository(Ref ref) {
  return SettingsRepositoryImpl();
}

/// Provides the GetSettings use case, injecting the repository.
@riverpod
GetSettings getSettings(Ref ref) {
  return GetSettings(ref.watch(settingsRepositoryProvider));
}

/// Provides the UpdateTheme use case.
@riverpod
UpdateTheme updateTheme(Ref ref) {
  return UpdateTheme(ref.watch(settingsRepositoryProvider));
}

/// Provides the UpdateLocale use case.
@riverpod
UpdateLocale updateLocale(Ref ref) {
  return UpdateLocale(ref.watch(settingsRepositoryProvider));
}
