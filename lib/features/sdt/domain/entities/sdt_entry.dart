// Project Imports
import 'package:sdt/features/sdt/domain/entities/sdt_settings.dart';

enum SdtQueryType { since, to }

class SdtEntry {
  final int? id;
  final String title;
  final DateTime date;
  final String? description;
  final String? imageUrl;
  final SdtSettings? settings;

  SdtEntry({
    this.id,
    required this.title,
    required this.date,
    this.description,
    this.imageUrl,
    this.settings,
  });

  SdtEntry copyWith({
    int? id,
    String? title,
    DateTime? date,
    String? description,
    String? imageUrl,
    SdtSettings? settings,
  }) {
    return SdtEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      settings: settings ?? this.settings,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'description': description,
      'image_url': imageUrl,
      'settings': settings?.toJson(),
    };
  }

  factory SdtEntry.fromMap(Map<String, dynamic> map) {
    return SdtEntry(
      id: map['id'] as int?,
      title: map['title'] as String,
      date: DateTime.parse(map['date'] as String),
      description: map['description'] as String?,
      imageUrl: map['image_url'] as String?,
      settings: map['settings'] != null
          ? SdtSettings.fromJson(map['settings'] as String)
          : null,
    );
  }
}
