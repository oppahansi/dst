// Package Imports
import "package:flutter/material.dart";

// Project Imports
import "package:sdtpro/core/utils/constants.dart";

enum SdtSortOrder { asc, desc }

class Settings {
  final ThemeMode themeMode;
  final Locale locale;
  final SdtSortOrder dsSortOrder;
  final SdtSortOrder dtSortOrder;

  const Settings({
    required this.themeMode,
    required this.locale,
    this.dsSortOrder = SdtSortOrder.asc,
    this.dtSortOrder = SdtSortOrder.asc,
  });

  Settings copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    SdtSortOrder? dsSortOrder,
    SdtSortOrder? dtSortOrder,
  }) {
    return Settings(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      dsSortOrder: dsSortOrder ?? this.dsSortOrder,
      dtSortOrder: dtSortOrder ?? this.dtSortOrder,
    );
  }

  factory Settings.defaultSettings() => const Settings(
    themeMode: ThemeMode.system,
    locale: Locale(settingsValueLocaleDefault),
    dsSortOrder: SdtSortOrder.asc,
    dtSortOrder: SdtSortOrder.asc,
  );

  static String _orderToStr(SdtSortOrder o) =>
      o == SdtSortOrder.asc ? 'asc' : 'desc';
  static SdtSortOrder _strToOrder(String? s) =>
      s == 'desc' ? SdtSortOrder.desc : SdtSortOrder.asc;

  Map<String, dynamic> toMap() {
    return {
      'themeMode': themeMode.toString(),
      'locale': locale.toString(),
      'dsSortOrder': _orderToStr(dsSortOrder),
      'dtSortOrder': _orderToStr(dtSortOrder),
    };
  }

  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      themeMode: ThemeMode.values.firstWhere(
        (e) => e.toString() == map['themeMode'],
      ),
      locale: Locale(map['locale']),
      dsSortOrder: _strToOrder(map['dsSortOrder'] as String?),
      dtSortOrder: _strToOrder(map['dtSortOrder'] as String?),
    );
  }
}
