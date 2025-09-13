// Dart Imports
import 'dart:convert';

// Flutter Imports
import 'package:flutter/material.dart';

// Package Imports
import 'package:material_symbols_icons/symbols.dart';

class SdtSettings {
  // Overlay
  final Color overlayColor;
  final double overlayAlpha;

  // Icon
  final IconData icon;

  // Divider
  final double dividerThickness;

  // Days Text
  final String daysFontFamily;
  final double daysFontSize;
  final FontWeight daysFontWeight;
  // NEW: color for days text
  final Color daysColor;

  // Title Text
  final String titleFontFamily;
  final double titleFontSize;
  final FontWeight titleFontWeight;
  // NEW: color for title text
  final Color titleColor;

  // Subtitle Text
  final String subtitleFontFamily;
  final double subtitleFontSize;
  final FontWeight subtitleFontWeight;
  final Color subtitleColor;
  final bool showSubtitleDate;
  final String subtitleDateFormat;

  // Whether to count today as 1 when computing days since/to.
  final bool countToday;

  SdtSettings({
    this.overlayColor = Colors.black,
    this.overlayAlpha = 0.4,
    this.icon = Symbols.star,
    this.dividerThickness = 1.0,
    this.daysFontFamily = 'System',
    this.daysFontSize = 120.0,
    this.daysFontWeight = FontWeight.w700,
    // NEW defaults
    this.daysColor = Colors.white,
    this.titleFontFamily = 'System',
    this.titleFontSize = 32.0,
    this.titleFontWeight = FontWeight.w500,
    // NEW defaults
    this.titleColor = Colors.white,
    this.subtitleFontFamily = 'System',
    this.subtitleFontSize = 16.0,
    this.subtitleFontWeight = FontWeight.normal,
    this.subtitleColor = Colors.white70,
    this.showSubtitleDate = true,
    this.subtitleDateFormat = 'dd.MM.yyyy',
    // Counting mode
    this.countToday = false,
  });

  // Helper to get font weight from an index, as it's easier to store.
  static FontWeight _fontWeightFromIndex(int index) {
    return FontWeight.values.firstWhere(
      (w) => w.index == index,
      orElse: () => FontWeight.normal,
    );
  }

  SdtSettings copyWith({
    Color? overlayColor,
    double? overlayAlpha,
    IconData? icon,
    double? dividerThickness,
    String? daysFontFamily,
    double? daysFontSize,
    FontWeight? daysFontWeight,
    // NEW
    Color? daysColor,
    String? titleFontFamily,
    double? titleFontSize,
    FontWeight? titleFontWeight,
    // NEW
    Color? titleColor,
    String? subtitleFontFamily,
    double? subtitleFontSize,
    FontWeight? subtitleFontWeight,
    Color? subtitleColor,
    bool? showSubtitleDate,
    String? subtitleDateFormat,
    bool? countToday,
  }) {
    return SdtSettings(
      overlayColor: overlayColor ?? this.overlayColor,
      overlayAlpha: overlayAlpha ?? this.overlayAlpha,
      icon: icon ?? this.icon,
      dividerThickness: dividerThickness ?? this.dividerThickness,
      daysFontFamily: daysFontFamily ?? this.daysFontFamily,
      daysFontSize: daysFontSize ?? this.daysFontSize,
      daysFontWeight: daysFontWeight ?? this.daysFontWeight,
      // NEW
      daysColor: daysColor ?? this.daysColor,
      titleFontFamily: titleFontFamily ?? this.titleFontFamily,
      titleFontSize: titleFontSize ?? this.titleFontSize,
      titleFontWeight: titleFontWeight ?? this.titleFontWeight,
      // NEW
      titleColor: titleColor ?? this.titleColor,
      subtitleFontFamily: subtitleFontFamily ?? this.subtitleFontFamily,
      subtitleFontSize: subtitleFontSize ?? this.subtitleFontSize,
      subtitleFontWeight: subtitleFontWeight ?? this.subtitleFontWeight,
      subtitleColor: subtitleColor ?? this.subtitleColor,
      showSubtitleDate: showSubtitleDate ?? this.showSubtitleDate,
      subtitleDateFormat: subtitleDateFormat ?? this.subtitleDateFormat,
      countToday: countToday ?? this.countToday,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'overlayColor': overlayColor.toARGB32(),
      'overlayAlpha': overlayAlpha,
      'iconCodePoint': icon.codePoint,
      'iconFontFamily': icon.fontFamily,
      'iconFontPackage': icon.fontPackage,
      'dividerThickness': dividerThickness,
      'daysFontFamily': daysFontFamily,
      'daysFontSize': daysFontSize,
      'daysFontWeightIndex': daysFontWeight.index,
      // NEW
      'daysColor': daysColor.toARGB32(),
      'titleFontFamily': titleFontFamily,
      'titleFontSize': titleFontSize,
      'titleFontWeightIndex': titleFontWeight.index,
      // NEW
      'titleColor': titleColor.toARGB32(),
      'subtitleFontFamily': subtitleFontFamily,
      'subtitleFontSize': subtitleFontSize,
      'subtitleFontWeightIndex': subtitleFontWeight.index,
      'subtitleColor': subtitleColor.toARGB32(),
      'showSubtitleDate': showSubtitleDate,
      'subtitleDateFormat': subtitleDateFormat,
    };
  }

  factory SdtSettings.fromMap(Map<String, dynamic> map) {
    return SdtSettings(
      overlayColor: Color(map['overlayColor'] ?? Colors.black.toARGB32()),
      overlayAlpha: map['overlayAlpha']?.toDouble() ?? 0.4,
      icon: IconData(
        map['iconCodePoint'] ?? Symbols.star.codePoint,
        fontFamily: map['iconFontFamily'] ?? 'MaterialSymbols',
        fontPackage: map['iconFontPackage'] ?? 'material_symbols_icons',
      ),
      dividerThickness: map['dividerThickness']?.toDouble() ?? 1.0,
      daysFontFamily: map['daysFontFamily'] ?? 'System',
      daysFontSize: map['daysFontSize']?.toDouble() ?? 120.0,
      daysFontWeight: _fontWeightFromIndex(map['daysFontWeightIndex'] ?? 6),
      // NEW
      daysColor: Color(map['daysColor'] ?? Colors.white.toARGB32()),
      titleFontFamily: map['titleFontFamily'] ?? 'System',
      titleFontSize: map['titleFontSize']?.toDouble() ?? 32.0,
      titleFontWeight: _fontWeightFromIndex(map['titleFontWeightIndex'] ?? 5),
      // NEW
      titleColor: Color(map['titleColor'] ?? Colors.white.toARGB32()),
      subtitleFontFamily: map['subtitleFontFamily'] ?? 'System',
      subtitleFontSize: map['subtitleFontSize']?.toDouble() ?? 16.0,
      subtitleFontWeight: _fontWeightFromIndex(
        map['subtitleFontWeightIndex'] ?? 3,
      ),
      subtitleColor: Color(map['subtitleColor'] ?? Colors.white70.toARGB32()),
      showSubtitleDate: map['showSubtitleDate'] ?? true,
      subtitleDateFormat: map['subtitleDateFormat'] ?? 'dd.MM.yyyy',
    );
  }

  String toJson() => json.encode(toMap());

  factory SdtSettings.fromJson(String source) {
    if (source.isEmpty) return SdtSettings();
    try {
      return SdtSettings.fromMap(json.decode(source));
    } catch (e) {
      // If decoding fails, return default settings
      return SdtSettings();
    }
  }
}
