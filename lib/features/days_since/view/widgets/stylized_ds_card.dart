// Dart Imports
import 'dart:io';

// Flutter Imports
import 'package:flutter/material.dart';

// Package Imports
import 'package:exui/exui.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

// Project Imports
import 'package:sdtpro/core/utils/text_styles.dart';
import 'package:sdtpro/core/utils/screen_sizes.dart';
import 'package:sdtpro/features/days_since/view/screens/stylized_ds_background_image.dart';
import 'package:sdtpro/features/days_since/view/screens/stylized_ds_content.dart';
import 'package:sdtpro/features/days_since/view/screens/ds_detail_screen.dart';
import 'package:sdtpro/features/days_since/domain/entities/days_since_entry.dart';
import 'package:sdtpro/features/days_since/domain/entities/stylized_settings.dart';
import 'package:sdtpro/l10n/app_localizations.dart';

class DsCard extends StatefulWidget {
  final DaysSinceEntry entry;
  final bool isTappable;
  const DsCard({super.key, required this.entry, this.isTappable = true});

  @override
  State<DsCard> createState() => _DsCardState();
}

class _DsCardState extends State<DsCard> {
  final _screenshotController = ScreenshotController();

  Future<void> _captureAndShareScreenshot() async {
    final loc = AppLocalizations.of(context)!;
    // We use `captureFromLongWidget` to render the full-screen content off-screen.
    final imageBytes = await _screenshotController.captureFromLongWidget(
      _buildScreenshotWidget(context),
      pixelRatio: MediaQuery.of(context).devicePixelRatio,
      constraints: const BoxConstraints(maxHeight: 1920, maxWidth: 1080),
    );

    if (!mounted) return;

    final directory = await getTemporaryDirectory();
    final imagePath = await File(
      '${directory.path}/sdt_share_${DateTime.now().millisecondsSinceEpoch}.png',
    ).create();
    await imagePath.writeAsBytes(imageBytes);

    final params = ShareParams(
      text: loc.days_since_title(widget.entry.title),
      files: [XFile(imagePath.path)],
    );

    await SharePlus.instance.share(params);
  }

  /// This builds the same widget tree as the `DaysSinceScreenshotScreen`
  /// to be captured as an image, without needing to navigate to the screen.
  Widget _buildScreenshotWidget(BuildContext context) {
    final settings = widget.entry.stylizedSettings ?? StylizedSettings();

    return RepaintBoundary(
      child: Material(
        color: Colors.black,
        child: AspectRatio(
          aspectRatio: 9 / 16, // Common phone screen aspect ratio
          child: Stack(
            fit: StackFit.expand,
            children: [
              StylizedDsBackgroundImage(imageUrl: widget.entry.imageUrl),
              Container(
                color: settings.overlayColor.withAlpha(
                  (settings.overlayAlpha * 255).round(),
                ),
              ),
              StylizedDsContent(
                entry: widget.entry,
                settings: settings,
                contentContext: StylizedContentContext.fullscreen,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = widget.entry.stylizedSettings ?? StylizedSettings();
    final loc = AppLocalizations.of(context)!;
    final days = DateTime.now().difference(widget.entry.date).inDays;
    final daysSince = widget.entry.stylizedSettings!.showSubtitleDate
        ? '${loc.days_since} ${DateFormat(settings.subtitleDateFormat, loc.localeName).format(widget.entry.date)}'
        : loc.days_since;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      color: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          Positioned.fill(
            child: StylizedDsBackgroundImage(imageUrl: widget.entry.imageUrl),
          ),
          Positioned.fill(
            child: Container(
              color: settings.overlayColor.withAlpha(
                (settings.overlayAlpha * 255).round(),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "$days",
                    style: TextStyle(
                      fontFamily: settings.daysFontFamily == 'System'
                          ? null
                          : settings.daysFontFamily,
                      color: Colors.white,
                      fontSize: headlineMedium(context)!.fontSize,
                      fontWeight: settings.daysFontWeight,
                    ),
                  ),
                  Text(
                    daysSince,
                    style: TextStyle(
                      fontFamily: settings.subtitleFontFamily == 'System'
                          ? null
                          : settings.subtitleFontFamily,
                      color: Colors.white,
                      fontSize: bodySmall(context)!.fontSize,
                      fontWeight: settings.subtitleFontWeight,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      widget.entry.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: settings.titleFontFamily == 'System'
                            ? null
                            : settings.titleFontFamily,
                        color: Colors.white,
                        fontSize: bodyMedium(context)!.fontSize,
                        fontWeight: settings.titleFontWeight,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: gapSize(context),
                    icon: Symbols.share.icon(),
                    color: Colors.white,
                    tooltip: loc.share,
                    onPressed: _captureAndShareScreenshot,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withAlpha(50),
                    ),
                  ),
                  IconButton(
                    iconSize: gapSize(context),
                    icon: Symbols.keyboard_arrow_right.icon(),
                    color: Colors.white,
                    tooltip: loc.open,
                    onPressed: () {
                      if (!widget.isTappable) return;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              DsDetailScreen(entry: widget.entry),
                        ),
                      );
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withAlpha(50),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
