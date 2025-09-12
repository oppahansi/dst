// Project Imports
import 'package:sdtpro/features/days_since/domain/entities/ds_settings.dart';

class DsEntry {
  final int? id;
  final String title;
  final DateTime date;
  final String? description;
  final String? imageUrl;
  final DsSettings? settings;

  DsEntry({
    this.id,
    required this.title,
    required this.date,
    this.description,
    this.imageUrl,
    this.settings,
  });

  DsEntry copyWith({
    int? id,
    String? title,
    DateTime? date,
    String? description,
    String? imageUrl,
    DsSettings? settings,
  }) {
    return DsEntry(
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

  factory DsEntry.fromMap(Map<String, dynamic> map) {
    return DsEntry(
      id: map['id'] as int?,
      title: map['title'] as String,
      date: DateTime.parse(map['date'] as String),
      description: map['description'] as String?,
      imageUrl: map['image_url'] as String?,
      settings: map['settings'] != null
          ? DsSettings.fromJson(map['settings'] as String)
          : null,
    );
  }
}
