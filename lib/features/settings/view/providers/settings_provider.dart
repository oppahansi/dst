// Package Imports
import "package:flutter/material.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

// Project Imports
import "package:sdtpro/features/settings/data/settings_repo_impl.dart";
import "package:sdtpro/features/settings/domain/entities/settings.dart";
import 'package:sdtpro/features/settings/domain/usecases/get_settings.dart';
import 'package:sdtpro/features/settings/view/providers/settings_usecase_providers.dart';

part "settings_provider.g.dart";

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  final Settings? _initialSettings;

  SettingsNotifier([this._initialSettings]);

  @override
  Settings build() {
    return _initialSettings ?? Settings.defaultSettings();
  }

  Future<void> updateThemeMode(ThemeMode themeMode) async {
    // Call the use case, which handles the business logic.
    await ref.read(updateThemeProvider).call(themeMode);
    // Update the UI state.
    state = state.copyWith(themeMode: themeMode);
  }

  Future<void> updateLocale(Locale locale) async {
    await ref.read(updateLocaleProvider).call(locale);
    state = state.copyWith(locale: locale);
  }
}

Future<Settings> loadInitialSettings() async {
  // Outside the widget tree, we can compose our dependencies manually.
  final getSettingsUseCase = GetSettings(SettingsRepoImpl());
  final settings = await getSettingsUseCase.call();
  return settings;
}
