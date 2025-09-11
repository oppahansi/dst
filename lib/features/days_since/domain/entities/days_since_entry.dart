// Project Imports
// Dart imports
import 'package:sdtpro/features/days_since/domain/entities/stylized_settings.dart';

enum StylizedLayoutMode {
  defaultLayout,
  outlinedDays;

  static StylizedLayoutMode fromString(String? mode) {
    return StylizedLayoutMode.values.firstWhere(
      (e) => e.name == mode,
      orElse: () => StylizedLayoutMode.defaultLayout,
    );
  }
}

enum DaysSinceDisplayMode {
  stylized,
  simple;

  static DaysSinceDisplayMode fromString(String? mode) {
    return DaysSinceDisplayMode.values.firstWhere(
      (e) => e.name == mode,
      orElse: () => DaysSinceDisplayMode.simple,
    );
  }
}

class DaysSinceEntry {
  final int? id;
  final String title;
  final DateTime date;
  final String? description;
  final String? imageUrl;
  final DaysSinceDisplayMode displayMode;
  final StylizedLayoutMode stylizedLayout;
  final StylizedSettings? stylizedSettings;

  DaysSinceEntry({
    this.id,
    required this.title,
    required this.date,
    this.description,
    this.imageUrl,
    required this.displayMode,
    this.stylizedLayout = StylizedLayoutMode.defaultLayout,
    this.stylizedSettings,
  });

  DaysSinceEntry copyWith({
    int? id,
    String? title,
    DateTime? date,
    String? description,
    String? imageUrl,
    DaysSinceDisplayMode? displayMode,
    StylizedLayoutMode? stylizedLayout,
    StylizedSettings? stylizedSettings,
  }) {
    return DaysSinceEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      displayMode: displayMode ?? this.displayMode,
      stylizedLayout: stylizedLayout ?? this.stylizedLayout,
      stylizedSettings: stylizedSettings ?? this.stylizedSettings,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'description': description,
      'image_url': imageUrl,
      'display_mode': displayMode.name,
      'stylized_layout': stylizedLayout.name,
      'stylized_settings': stylizedSettings?.toJson(),
    };
  }

  factory DaysSinceEntry.fromMap(Map<String, dynamic> map) {
    return DaysSinceEntry(
      id: map['id'] as int?,
      title: map['title'] as String,
      date: DateTime.parse(map['date'] as String),
      description: map['description'] as String?,
      imageUrl: map['image_url'] as String?,
      displayMode: DaysSinceDisplayMode.fromString(
        map['display_mode'] as String?,
      ),
      stylizedLayout: StylizedLayoutMode.fromString(
        map['stylized_layout'] as String?,
      ),
      stylizedSettings: map['stylized_settings'] != null
          ? StylizedSettings.fromJson(map['stylized_settings'] as String)
          : null,
    );
  }
}
