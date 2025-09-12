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
import 'package:sdtpro/core/utils/extensions.dart';
import 'package:sdtpro/features/days_since/view/screens/ds_screenshot_screen.dart';
import 'package:sdtpro/features/days_since/view/widgets/ds_background_image.dart';
import 'package:sdtpro/core/utils/text_styles.dart';
import 'package:sdtpro/core/utils/screen_sizes.dart';
import 'package:sdtpro/features/days_since/view/widgets/ds_content.dart';
import 'package:sdtpro/features/days_since/view/screens/ds_detail_screen.dart';
import 'package:sdtpro/features/days_since/domain/entities/ds_entry.dart';
import 'package:sdtpro/features/days_since/domain/entities/ds_settings.dart';
import 'package:sdtpro/l10n/app_localizations.dart';

class DsCard extends StatefulWidget {
  final DsEntry entry;
  final bool isTappable;
  const DsCard({super.key, required this.entry, this.isTappable = true});

  @override
  State<DsCard> createState() => _DsCardState();
}

class _DsCardState extends State<DsCard> {
  final _screenshotController = ScreenshotController();
  bool _isSharing = false; // overlay while preparing image

  Future<void> _captureAndShareScreenshot() async {
    final loc = AppLocalizations.of(context)!;

    if (mounted) setState(() => _isSharing = true);
    try {
      final mq = MediaQuery.of(context);
      final pixelRatio = mq.devicePixelRatio;

      // Keep theme and localizations while rendering offstage.
      final widgetToCapture = Localizations.override(
        context: context,
        child: InheritedTheme.captureAll(
          context,
          MediaQuery(
            data: mq.copyWith(),
            child: _buildScreenshotWidget(context),
          ),
        ),
      );

      final imageBytes = await _screenshotController.captureFromLongWidget(
        widgetToCapture,
        pixelRatio: pixelRatio,
        constraints: BoxConstraints.tightFor(
          width: mq.size.width,
          height: mq.size.height,
        ),
      );

      if (!mounted || imageBytes.isEmpty) {
        if (mounted) {
          context.showSnackBar(
            SnackBar(content: Text(loc.failed_to_load_images)),
          );
        }
        return;
      }

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
    } catch (e) {
      if (mounted) {
        context.showSnackBar(SnackBar(content: Text('Share failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  /// This builds the same widget tree as the `DaysSinceScreenshotScreen`
  /// to be captured as an image, without needing to navigate to the screen.
  Widget _buildScreenshotWidget(BuildContext context) {
    final settings = widget.entry.settings ?? DsSettings();

    return Directionality(
      // ensure Text has a Directionality when rendered offstage
      textDirection: Directionality.of(context),
      child: RepaintBoundary(
        child: Material(
          color: Colors.black,
          child: AspectRatio(
            aspectRatio: 9 / 16, // Common phone screen aspect ratio
            child: Stack(
              fit: StackFit.expand,
              children: [
                DsBackgroundImage(imageUrl: widget.entry.imageUrl),
                Container(
                  color: settings.overlayColor.withAlpha(
                    (settings.overlayAlpha * 255).round(),
                  ),
                ),
                DsContent(
                  entry: widget.entry,
                  settings: settings,
                  contentContext: DsContentContext.fullscreen,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = widget.entry.settings ?? DsSettings();
    final loc = AppLocalizations.of(context)!;
    final days = DateTime.now().difference(widget.entry.date).inDays;
    final daysSince = settings.showSubtitleDate
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
            child: DsBackgroundImage(imageUrl: widget.entry.imageUrl),
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
                    icon: const Icon(Symbols.screenshot),
                    tooltip: loc.screenshot_view,
                    color: Colors.white,
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DsScreenshotScreen(entry: widget.entry),
                      ),
                    ),
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

          // Loading overlay while preparing the screenshot/share
          if (_isSharing)
            Positioned.fill(
              child: AbsorbPointer(
                child: Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
