// Flutter Imports
import 'package:flutter/material.dart';

// Package Imports
import 'package:intl/intl.dart';

// Project Imports
import 'package:sdtpro/features/sdt/domain/entities/sdt_entry.dart';
import 'package:sdtpro/features/sdt/domain/entities/sdt_settings.dart';
import 'package:sdtpro/l10n/app_localizations.dart';

enum SdtContentContext { card, fullscreen, editor }

class SdtContent extends StatelessWidget {
  final SdtEntry entry;
  final SdtSettings settings;
  final SdtContentContext contentContext;
  final TextEditingController? titleController;

  const SdtContent({
    super.key,
    required this.entry,
    required this.settings,
    this.contentContext = SdtContentContext.card,
    this.titleController,
  });

  double _getFontSize(double baseSize) {
    switch (contentContext) {
      case SdtContentContext.card:
        return baseSize * 0.5;
      case SdtContentContext.fullscreen:
      case SdtContentContext.editor:
        return baseSize;
    }
  }

  TextStyle _applyFont(String family, TextStyle base) {
    if (family == 'System' || family.isEmpty) return base;
    return base.copyWith(fontFamily: family);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    // Normalize to date-only to avoid time-of-day affecting the count
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDate = DateTime(
      entry.date.year,
      entry.date.month,
      entry.date.day,
    );

    final isFuture = eventDate.isAfter(today);
    final days = (eventDate.difference(today).inDays).abs();

    final subtitle = settings.showSubtitleDate
        ? '${isFuture ? loc.days_to : loc.days_since} ${DateFormat(settings.subtitleDateFormat, loc.localeName).format(entry.date)}'
        : (isFuture ? loc.days_to : loc.days_since);

    final mainContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$days',
          style: _applyFont(
            settings.daysFontFamily,
            TextStyle(
              fontSize: _getFontSize(settings.daysFontSize),
              color: settings.daysColor, // was Colors.white
              fontWeight: settings.daysFontWeight,
              shadows: const [Shadow(blurRadius: 8, color: Colors.black54)],
            ),
          ),
        ),
        Text(
          subtitle,
          style: _applyFont(
            settings.subtitleFontFamily,
            TextStyle(
              color: settings.subtitleColor,
              fontSize: _getFontSize(settings.subtitleFontSize),
              fontWeight: settings.subtitleFontWeight,
            ),
          ),
        ),
        SizedBox(height: _getFontSize(24)),
        Row(
          children: [
            Expanded(
              child: Divider(
                color: Colors.white70,
                thickness: settings.dividerThickness,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: _getFontSize(16)),
              child: Icon(
                settings.icon,
                color: Colors.white,
                size: _getFontSize(28),
              ),
            ),
            Expanded(
              child: Divider(
                color: Colors.white70,
                thickness: settings.dividerThickness,
              ),
            ),
          ],
        ),
        SizedBox(height: _getFontSize(16)),
        if (contentContext == SdtContentContext.editor &&
            titleController != null)
          TextField(
            controller: titleController,
            textAlign: TextAlign.center,
            maxLines: null,
            style: _applyFont(
              settings.titleFontFamily,
              TextStyle(
                color: settings.titleColor, // was Colors.white
                fontSize: _getFontSize(settings.titleFontSize),
                fontWeight: settings.titleFontWeight,
                shadows: const [Shadow(blurRadius: 4, color: Colors.black45)],
              ),
            ),
            decoration: InputDecoration(
              fillColor: Colors.transparent,
              border: InputBorder.none,
              hintText: loc.title,
              hintStyle: TextStyle(
                color: settings.titleColor.withAlpha(128), // was white alpha
                fontWeight: FontWeight.normal,
              ),
            ),
          )
        else
          Text(
            entry.title,
            textAlign: TextAlign.center,
            style: _applyFont(
              settings.titleFontFamily,
              TextStyle(
                color: settings.titleColor, // was Colors.white
                fontSize: _getFontSize(settings.titleFontSize),
                fontWeight: settings.titleFontWeight,
                shadows: const [Shadow(blurRadius: 4, color: Colors.black45)],
              ),
            ),
          ),
      ],
    );

    if (contentContext == SdtContentContext.card) {
      return mainContent;
    }

    return Center(
      child: Padding(padding: const EdgeInsets.all(16.0), child: mainContent),
    );
  }
}
