// Dart Imports
import 'dart:convert';

// Flutter Imports
import 'package:flutter/material.dart';

// Package Imports
import 'package:material_symbols_icons/symbols.dart';

class StylizedSettings {
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

  // Title Text
  final String titleFontFamily;
  final double titleFontSize;
  final FontWeight titleFontWeight;

  // Subtitle Text
  final String subtitleFontFamily;
  final double subtitleFontSize;
  final FontWeight subtitleFontWeight;
  final Color subtitleColor;
  final bool showSubtitleDate;
  final String subtitleDateFormat;

  StylizedSettings({
    this.overlayColor = Colors.black,
    this.overlayAlpha = 0.4,
    this.icon = Symbols.star,
    this.dividerThickness = 1.0,
    this.daysFontFamily = 'System',
    this.daysFontSize = 120.0,
    this.daysFontWeight = FontWeight.w700,
    this.titleFontFamily = 'System',
    this.titleFontSize = 32.0,
    this.titleFontWeight = FontWeight.w500,
    this.subtitleFontFamily = 'System',
    this.subtitleFontSize = 16.0,
    this.subtitleFontWeight = FontWeight.normal,
    this.subtitleColor = Colors.white70,
    this.showSubtitleDate = true,
    this.subtitleDateFormat = 'yMMMd',
  });

  // Helper to get font weight from an index, as it's easier to store.
  static FontWeight _fontWeightFromIndex(int index) {
    return FontWeight.values.firstWhere(
      (w) => w.index == index,
      orElse: () => FontWeight.normal,
    );
  }

  StylizedSettings copyWith({
    Color? overlayColor,
    double? overlayAlpha,
    IconData? icon,
    double? dividerThickness,
    String? daysFontFamily,
    double? daysFontSize,
    FontWeight? daysFontWeight,
    String? titleFontFamily,
    double? titleFontSize,
    FontWeight? titleFontWeight,
    String? subtitleFontFamily,
    double? subtitleFontSize,
    FontWeight? subtitleFontWeight,
    Color? subtitleColor,
    bool? showSubtitleDate,
    String? subtitleDateFormat,
  }) {
    return StylizedSettings(
      overlayColor: overlayColor ?? this.overlayColor,
      overlayAlpha: overlayAlpha ?? this.overlayAlpha,
      icon: icon ?? this.icon,
      dividerThickness: dividerThickness ?? this.dividerThickness,
      daysFontFamily: daysFontFamily ?? this.daysFontFamily,
      daysFontSize: daysFontSize ?? this.daysFontSize,
      daysFontWeight: daysFontWeight ?? this.daysFontWeight,
      titleFontFamily: titleFontFamily ?? this.titleFontFamily,
      titleFontSize: titleFontSize ?? this.titleFontSize,
      titleFontWeight: titleFontWeight ?? this.titleFontWeight,
      subtitleFontFamily: subtitleFontFamily ?? this.subtitleFontFamily,
      subtitleFontSize: subtitleFontSize ?? this.subtitleFontSize,
      subtitleFontWeight: subtitleFontWeight ?? this.subtitleFontWeight,
      subtitleColor: subtitleColor ?? this.subtitleColor,
      showSubtitleDate: showSubtitleDate ?? this.showSubtitleDate,
      subtitleDateFormat: subtitleDateFormat ?? this.subtitleDateFormat,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'overlayColor': overlayColor.value,
      'overlayAlpha': overlayAlpha,
      'iconCodePoint': icon.codePoint,
      'iconFontFamily': icon.fontFamily,
      'iconFontPackage': icon.fontPackage,
      'dividerThickness': dividerThickness,
      'daysFontFamily': daysFontFamily,
      'daysFontSize': daysFontSize,
      'daysFontWeightIndex': daysFontWeight.index,
      'titleFontFamily': titleFontFamily,
      'titleFontSize': titleFontSize,
      'titleFontWeightIndex': titleFontWeight.index,
      'subtitleFontFamily': subtitleFontFamily,
      'subtitleFontSize': subtitleFontSize,
      'subtitleFontWeightIndex': subtitleFontWeight.index,
      'subtitleColor': subtitleColor.value,
      'showSubtitleDate': showSubtitleDate,
      'subtitleDateFormat': subtitleDateFormat,
    };
  }

  factory StylizedSettings.fromMap(Map<String, dynamic> map) {
    return StylizedSettings(
      overlayColor: Color(map['overlayColor'] ?? Colors.black.value),
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
      titleFontFamily: map['titleFontFamily'] ?? 'System',
      titleFontSize: map['titleFontSize']?.toDouble() ?? 32.0,
      titleFontWeight: _fontWeightFromIndex(map['titleFontWeightIndex'] ?? 4),
      subtitleFontFamily: map['subtitleFontFamily'] ?? 'System',
      subtitleFontSize: map['subtitleFontSize']?.toDouble() ?? 16.0,
      subtitleFontWeight: _fontWeightFromIndex(
        map['subtitleFontWeightIndex'] ?? 3,
      ),
      subtitleColor: Color(map['subtitleColor'] ?? Colors.white70.value),
      showSubtitleDate: map['showSubtitleDate'] as bool? ?? true,
      subtitleDateFormat: map['subtitleDateFormat'] as String? ?? 'yMMMd',
    );
  }

  String toJson() => json.encode(toMap());

  factory StylizedSettings.fromJson(String source) {
    if (source.isEmpty) return StylizedSettings();
    try {
      return StylizedSettings.fromMap(json.decode(source));
    } catch (e) {
      // If decoding fails, return default settings
      return StylizedSettings();
    }
  }
}
