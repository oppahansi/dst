// Package Imports
import "package:flutter/material.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

// Project Imports
import "package:sdtpro/features/settings/data/settings_repository_impl.dart";
import "package:sdtpro/features/settings/domain/entities/settings.dart";

part "settings_provider.g.dart";

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  final Settings? _initialSettings;

  SettingsNotifier([this._initialSettings]);

  final _repo = SettingsRepositoryImpl();

  @override
  Settings build() {
    return _initialSettings ?? Settings.defaultSettings();
  }

  Future<void> updateThemeMode(ThemeMode themeMode) async {
    await _repo.updateThemeMode(themeMode);
    state = state.copyWith(themeMode: themeMode);
  }

  Future<void> updateLocale(Locale locale) async {
    await _repo.updateLocale(locale);
    state = state.copyWith(locale: locale);
  }
}

Future<Settings> loadInitialSettings() async {
  final repo = SettingsRepositoryImpl();
  final settings = await repo.getSettings();
  return settings;
}
