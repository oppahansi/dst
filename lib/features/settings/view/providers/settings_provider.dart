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
    await ref.read(updateThemeProvider).call(themeMode);
    state = state.copyWith(themeMode: themeMode);
  }

  Future<void> updateLocale(Locale locale) async {
    await ref.read(updateLocaleProvider).call(locale);
    state = state.copyWith(locale: locale);
  }

  Future<void> updateDsSortOrder(SdtSortOrder order) async {
    await ref.read(updateDsSortOrderProvider).call(order);
    state = state.copyWith(dsSortOrder: order);
  }

  Future<void> updateDtSortOrder(SdtSortOrder order) async {
    await ref.read(updateDtSortOrderProvider).call(order);
    state = state.copyWith(dtSortOrder: order);
  }

  Future<void> updateCountToday(bool value) async {
    await ref.read(updateCountTodayProvider).call(value);
    state = state.copyWith(countToday: value);
  }

  Future<void> updateCountLastDay(bool value) async {
    await ref.read(updateCountLastDayProvider).call(value);
    state = state.copyWith(countLastDay: value);
  }

  Future<void> resetToDefaults() async {
    await ref.read(resetSettingsProvider).call();
    state = Settings.defaultSettings();
  }

  Future<void> setSeededExamples(bool value) async {
    await ref.read(updateSeededExamplesProvider).call(value);
    state = state.copyWith(seededExamples: value);
  }
}

Future<Settings> loadInitialSettings() async {
  final getSettingsUseCase = GetSettings(SettingsRepoImpl());
  final settings = await getSettingsUseCase.call();
  return settings;
}
