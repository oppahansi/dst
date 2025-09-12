// Package Imports
import "package:flutter/material.dart";
import "package:sqflite/sqflite.dart";

// Project Imports
import "package:sdtpro/core/db/db.dart";
import "package:sdtpro/core/utils/constants.dart";
import "package:sdtpro/features/settings/domain/entities/settings.dart";
import "package:sdtpro/features/settings/domain/repos/settings_repo.dart";

class SettingsRepoImpl implements SettingsRepo {
  static final SettingsRepoImpl _instance = SettingsRepoImpl._internal();
  factory SettingsRepoImpl() => _instance;
  SettingsRepoImpl._internal();

  static const String _table = "settings";

  Future<void> _setSetting(String key, String value) async {
    final db = await Db.getUserDbInstance();
    await db.insert(_table, {
      "key": key,
      "value": value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, String>> _getAllSettings() async {
    final db = await Db.getUserDbInstance();
    final settings = await db.query(_table);
    final Map<String, String> settingsMap = {};
    for (final setting in settings) {
      settingsMap[setting["key"] as String] = setting["value"] as String;
    }
    return settingsMap;
  }

  @override
  Future<Settings> getSettings() async {
    final settingsMap = await _getAllSettings();
    final themeMode = _getThemeModeFromString(
      settingsMap[settingsKeyThemeMode],
    );
    final locale = Locale(
      settingsMap[settingsKeyLocale] ?? settingsValueLocaleDefault,
    );

    final ds =
        await _readString(settingsKeyDsSortOrder) ?? SdtSortOrder.asc.name;
    final dt =
        await _readString(settingsKeyDtSortOrder) ?? SdtSortOrder.asc.name;

    return Settings(
      themeMode: themeMode,
      locale: locale,
      dsSortOrder: SdtSortOrder.values.byName(ds),
      dtSortOrder: SdtSortOrder.values.byName(dt),
    );
  }

  @override
  Future<void> updateLocale(Locale locale) async {
    await _setSetting(settingsKeyLocale, locale.languageCode);
  }

  @override
  Future<void> updateThemeMode(ThemeMode themeMode) async {
    String themeValue;
    switch (themeMode) {
      case ThemeMode.light:
        themeValue = settingsValueThemeModeLight;
        break;
      case ThemeMode.dark:
        themeValue = settingsValueThemeModeDark;
        break;
      case ThemeMode.system:
        themeValue = settingsValueThemeModeSystem;
    }
    await _setSetting(settingsKeyThemeMode, themeValue);
  }

  @override
  Future<void> updateDsSortOrder(SdtSortOrder order) async {
    await _setSetting(settingsKeyDsSortOrder, order.name);
  }

  @override
  Future<void> updateDtSortOrder(SdtSortOrder order) async {
    await _saveString(settingsKeyDtSortOrder, order.name);
  }

  Future<void> _saveString(String key, String value) async {
    final db = await Db.getUserDbInstance();
    await db.insert(_table, {
      "key": key,
      "value": value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  ThemeMode _getThemeModeFromString(String? themeStr) {
    // This logic is now correctly placed within the data layer.
    switch (themeStr) {
      case settingsValueThemeModeLight:
        return ThemeMode.light;
      case settingsValueThemeModeDark:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<String?> _readString(String key) async {
    final db = await Db.getUserDbInstance();
    final result = await db.query(_table, where: "key = ?", whereArgs: [key]);
    return result.isNotEmpty ? result.first["value"] as String : null;
  }
}
