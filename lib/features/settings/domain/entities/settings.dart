// Package Imports
import "package:flutter/material.dart";

// Project Imports
import "package:sdt/core/utils/constants.dart";

enum SdtSortOrder { asc, desc }

class Settings {
  final ThemeMode themeMode;
  final Locale locale;
  final SdtSortOrder dsSortOrder;
  final SdtSortOrder dtSortOrder;
  final bool countToday;
  final bool countLastDay;
  final bool seededExamples;

  const Settings({
    required this.themeMode,
    required this.locale,
    this.dsSortOrder = SdtSortOrder.asc,
    this.dtSortOrder = SdtSortOrder.asc,
    this.countToday = false,
    this.countLastDay = true,
    this.seededExamples = false,
  });

  Settings copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    SdtSortOrder? dsSortOrder,
    SdtSortOrder? dtSortOrder,
    bool? countToday,
    bool? countLastDay,
    bool? seededExamples,
  }) {
    return Settings(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      dsSortOrder: dsSortOrder ?? this.dsSortOrder,
      dtSortOrder: dtSortOrder ?? this.dtSortOrder,
      countToday: countToday ?? this.countToday,
      countLastDay: countLastDay ?? this.countLastDay,
      seededExamples: seededExamples ?? this.seededExamples,
    );
  }

  factory Settings.defaultSettings() => const Settings(
    themeMode: ThemeMode.system,
    locale: Locale(settingsValueLocaleDefault),
    dsSortOrder: SdtSortOrder.asc,
    dtSortOrder: SdtSortOrder.asc,
    countToday: false,
    countLastDay: true,
    seededExamples: false,
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
      'countToday': countToday,
      'countLastDay': countLastDay,
      'seededExamples': seededExamples,
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
      countToday: map['countToday'] as bool? ?? false,
      countLastDay: map['countLastDay'] as bool? ?? true,
      seededExamples: (map['seededExamples'] as bool?) ?? false,
    );
  }
}
