// Package Imports
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project Imports
import 'package:sdtpro/features/settings/data/settings_repo_impl.dart';
import 'package:sdtpro/features/settings/domain/repos/settings_repo.dart';
import 'package:sdtpro/features/settings/domain/usecases/get_settings.dart';
import 'package:sdtpro/features/settings/domain/usecases/update_ds_sort_order.dart';
import 'package:sdtpro/features/settings/domain/usecases/update_dt_sort_order.dart';
import 'package:sdtpro/features/settings/domain/usecases/update_locale.dart';
import 'package:sdtpro/features/settings/domain/usecases/update_theme.dart';
import 'package:sdtpro/features/settings/domain/usecases/update_count_today.dart';
import 'package:sdtpro/features/settings/domain/usecases/update_count_last_day.dart';
import 'package:sdtpro/features/settings/domain/usecases/reset_settings.dart';

part 'settings_usecase_providers.g.dart';

/// Provides the concrete implementation of the SettingsRepository.
/// In a real app, you might switch this out for a mock repository during tests.
@riverpod
SettingsRepo settingsRepo(Ref ref) {
  return SettingsRepoImpl();
}

/// Provides the GetSettings use case, injecting the repository.
@riverpod
GetSettings getSettings(Ref ref) {
  return GetSettings(ref.watch(settingsRepoProvider));
}

/// Provides the UpdateTheme use case.
@riverpod
UpdateTheme updateTheme(Ref ref) {
  return UpdateTheme(ref.watch(settingsRepoProvider));
}

/// Provides the UpdateLocale use case.
@riverpod
UpdateLocale updateLocale(Ref ref) {
  return UpdateLocale(ref.watch(settingsRepoProvider));
}

/// Provides the UpdateDsSortOrder use case.
@riverpod
UpdateDsSortOrder updateDsSortOrder(Ref ref) {
  return UpdateDsSortOrder(ref.watch(settingsRepoProvider));
}

/// Provides the UpdateDtSortOrder use case.
@riverpod
UpdateDtSortOrder updateDtSortOrder(Ref ref) {
  return UpdateDtSortOrder(ref.watch(settingsRepoProvider));
}

/// Provides the UpdateCountToday use case.
@riverpod
UpdateCountToday updateCountToday(Ref ref) {
  return UpdateCountToday(ref.watch(settingsRepoProvider));
}

/// Provides the UpdateCountLastDay use case.
@riverpod
UpdateCountLastDay updateCountLastDay(Ref ref) {
  return UpdateCountLastDay(ref.watch(settingsRepoProvider));
}

/// Provides the ResetSettings use case.
@riverpod
ResetSettings resetSettings(Ref ref) {
  return ResetSettings(ref.watch(settingsRepoProvider));
}
