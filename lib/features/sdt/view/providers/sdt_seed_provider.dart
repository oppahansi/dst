// Dart Imports
import 'dart:math';

// Flutter Imports
import 'package:flutter/material.dart';

// Package Imports
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project Imports
import 'package:sdtpro/features/sdt/domain/entities/sdt_entry.dart';
import 'package:sdtpro/features/sdt/domain/entities/sdt_settings.dart';
import 'package:sdtpro/features/sdt/view/providers/sdt_usecase_providers.dart';
import 'package:sdtpro/features/settings/view/providers/settings_provider.dart';

part 'sdt_seed_provider.g.dart';

Color _randomShade(Random r, MaterialColor mc) {
  final shades = <Color>[
    mc.shade100,
    mc.shade200,
    mc.shade300,
    mc.shade400,
    mc.shade500,
    mc.shade600,
    mc.shade700,
    mc.shade800,
    mc.shade900,
  ];
  return shades[r.nextInt(shades.length)];
}

const _fontFamilies = <String>[
  'System',
  'Roboto',
  'Merriweather',
  'Montserrat',
  'Oswald',
  'Poppins',
  'Raleway',
  'Lato',
  'Nunito',
];

SdtSettings _randomSettings() {
  final r = Random();
  final overlayPalette = Colors.primaries[r.nextInt(Colors.primaries.length)];
  final daysPalette = Colors.primaries[r.nextInt(Colors.primaries.length)];
  final titlePalette = Colors.primaries[r.nextInt(Colors.primaries.length)];
  final subtitlePalette = Colors.primaries[r.nextInt(Colors.primaries.length)];
  return SdtSettings().copyWith(
    overlayColor: overlayPalette.shade900,
    overlayAlpha: 0.25 + r.nextDouble() * 0.5,
    daysFontFamily: _fontFamilies[r.nextInt(_fontFamilies.length)],
    titleFontFamily: _fontFamilies[r.nextInt(_fontFamilies.length)],
    subtitleFontFamily: _fontFamilies[r.nextInt(_fontFamilies.length)],
    daysColor: _randomShade(r, daysPalette),
    titleColor: _randomShade(r, titlePalette),
    subtitleColor: _randomShade(r, subtitlePalette),
  );
}

@riverpod
Future<void> seedExamplesIfNeeded(Ref ref) async {
  final settings = ref.read(settingsNotifierProvider);
  if (settings.seededExamples) return;

  final repo = ref.read(sdtRepoProvider);
  final existing = await repo.getEntries();
  if (existing.isEmpty) {
    final now = DateTime.now();
    final samples = <SdtEntry>[
      SdtEntry(
        title: 'Sample: First day at work',
        date: now.subtract(const Duration(days: 10)),
        settings: _randomSettings(),
      ),
      SdtEntry(
        title: 'Sample: Weekend trip',
        date: now.subtract(const Duration(days: 3)),
        settings: _randomSettings(),
      ),
      SdtEntry(
        title: 'Sample: Friend\'s birthday',
        date: now.add(const Duration(days: 15)),
        settings: _randomSettings(),
      ),
      SdtEntry(
        title: 'Sample: Doctor appointment',
        date: now.add(const Duration(days: 45)),
        settings: _randomSettings(),
      ),
    ];
    for (final e in samples) {
      await repo.addEntry(e);
    }
  }

  // Mark as seeded regardless, so deleting all entries later won't re-seed
  await ref.read(settingsNotifierProvider.notifier).setSeededExamples(true);
}
