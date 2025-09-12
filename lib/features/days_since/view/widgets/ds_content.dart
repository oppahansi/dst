// Flutter Imports
import 'package:flutter/material.dart';

// Package Imports
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

// Project Imports
import 'package:sdtpro/features/days_since/domain/entities/ds_entry.dart';
import 'package:sdtpro/features/days_since/domain/entities/ds_settings.dart';
import 'package:sdtpro/l10n/app_localizations.dart';

enum DsContentContext { card, fullscreen, editor }

class DsContent extends StatelessWidget {
  final DsEntry entry;
  final DsSettings settings;
  final DsContentContext contentContext;
  final TextEditingController? titleController;

  const DsContent({
    super.key,
    required this.entry,
    required this.settings,
    this.contentContext = DsContentContext.card,
    this.titleController,
  });

  double _getFontSize(double baseSize) {
    switch (contentContext) {
      case DsContentContext.card:
        return baseSize * 0.5;
      case DsContentContext.fullscreen:
      case DsContentContext.editor:
        return baseSize;
    }
  }

  TextStyle _applyFont(String family, TextStyle base) {
    if (family == 'System' || family.isEmpty) return base;
    return GoogleFonts.getFont(family, textStyle: base);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final days = DateTime.now().difference(entry.date).inDays;

    final subtitle = settings.showSubtitleDate
        ? '${loc.days_since} ${DateFormat(settings.subtitleDateFormat, loc.localeName).format(entry.date)}'
        : loc.days_since;

    final mainContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$days',
          style: _applyFont(
            settings.daysFontFamily,
            TextStyle(
              fontSize: _getFontSize(settings.daysFontSize),
              color: Colors.white,
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
        if (contentContext == DsContentContext.editor &&
            titleController != null)
          TextField(
            controller: titleController,
            textAlign: TextAlign.center,
            maxLines: null,
            style: _applyFont(
              settings.titleFontFamily,
              TextStyle(
                color: Colors.white,
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
                color: Colors.white.withAlpha(128),
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
                color: Colors.white,
                fontSize: _getFontSize(settings.titleFontSize),
                fontWeight: settings.titleFontWeight,
                shadows: const [Shadow(blurRadius: 4, color: Colors.black45)],
              ),
            ),
          ),
      ],
    );

    if (contentContext == DsContentContext.card) {
      return mainContent;
    }

    return Center(
      child: Padding(padding: const EdgeInsets.all(16.0), child: mainContent),
    );
  }
}
