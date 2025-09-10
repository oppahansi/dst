// Dart Imports
// Dart imports

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

  DaysSinceEntry({
    this.id,
    required this.title,
    required this.date,
    this.description,
    this.imageUrl,
    required this.displayMode,
  });

  DaysSinceEntry copyWith({
    int? id,
    String? title,
    DateTime? date,
    String? description,
    String? imageUrl,
    DaysSinceDisplayMode? displayMode,
  }) {
    return DaysSinceEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      displayMode: displayMode ?? this.displayMode,
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
    );
  }
}
