// Dart Imports
import 'dart:io';
import 'dart:typed_data';

// Flutter Imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package Imports
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

// Project Imports
import 'package:sdtpro/core/utils/extensions.dart';
import 'package:sdtpro/features/days_since/domain/entities/days_since_entry.dart';
import 'package:sdtpro/features/days_since/domain/entities/stylized_settings.dart';
import 'package:sdtpro/l10n/app_localizations.dart';

class DaysSinceScreenshotScreen extends StatefulWidget {
  final DaysSinceEntry entry;

  const DaysSinceScreenshotScreen({super.key, required this.entry});

  @override
  State<DaysSinceScreenshotScreen> createState() =>
      _DaysSinceScreenshotScreenState();
}

class _DaysSinceScreenshotScreenState extends State<DaysSinceScreenshotScreen> {
  final _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    // Go into fullscreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    // Restore system UI when leaving the screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<void> _captureAndSaveScreenshot() async {
    final loc = AppLocalizations.of(context)!;
    // Capture the widget and get the image as raw bytes.
    final Uint8List? imageBytes = await _screenshotController.capture();

    if (imageBytes == null) return;

    // Save the image to the gallery.
    final result = await ImageGallerySaverPlus.saveImage(
      imageBytes,
      name: 'sdt_screenshot_${DateTime.now().millisecondsSinceEpoch}',
      isReturnImagePathOfIOS: true,
    );

    if (mounted && result['isSuccess'] == true) {
      context.showSnackBar(SnackBar(content: Text(loc.screenshot_saved)));
    }
  }

  Future<void> _captureAndShareScreenshot() async {
    final loc = AppLocalizations.of(context)!;
    final imageBytes = await _screenshotController.capture();

    if (imageBytes == null || !mounted) return;

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

  @override
  Widget build(BuildContext context) {
    final days = DateTime.now().difference(widget.entry.date).inDays;
    final loc = AppLocalizations.of(context)!;
    final settings = widget.entry.stylizedSettings ?? StylizedSettings();

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'share',
            onPressed: _captureAndShareScreenshot,
            tooltip: loc.share,
            child: const Icon(Symbols.share),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'save',
            onPressed: _captureAndSaveScreenshot,
            tooltip: loc.take_screenshot,
            child: const Icon(Symbols.camera),
          ),
        ],
      ),
      body: Screenshot(
        controller: _screenshotController,
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image (handles both network and local files)
              if (widget.entry.imageUrl != null) ...[
                if (widget.entry.imageUrl!.startsWith('http'))
                  CachedNetworkImage(
                    imageUrl: widget.entry.imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )
                else
                  Image.file(File(widget.entry.imageUrl!), fit: BoxFit.cover),
              ],

              // Overlay
              Container(
                color: settings.overlayColor.withAlpha(
                  (settings.overlayAlpha * 255).round(),
                ),
              ),

              // Content
              SafeArea(
                top: false,
                bottom: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$days',
                          style: TextStyle(
                            fontFamily: settings.daysFontFamily == 'System'
                                ? null
                                : settings.daysFontFamily,
                            fontSize: settings.daysFontSize,
                            color: Colors.white,
                            fontWeight: settings.daysFontWeight,
                            shadows: const [
                              Shadow(blurRadius: 8, color: Colors.black54),
                            ],
                          ),
                        ),
                        Text(
                          settings.showSubtitleDate
                              ? '${loc.days_since} ${DateFormat(settings.subtitleDateFormat, loc.localeName).format(widget.entry.date)}'
                              : loc.days_since,
                          style: TextStyle(
                            fontFamily: settings.subtitleFontFamily == 'System'
                                ? null
                                : settings.subtitleFontFamily,
                            color: settings.subtitleColor,
                            fontSize: settings.subtitleFontSize,
                            fontWeight: settings.subtitleFontWeight,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.white70,
                                thickness: settings.dividerThickness,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Icon(
                                settings.icon,
                                color: Colors.white,
                                size: 28,
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
                        const SizedBox(height: 16),
                        Text(
                          widget.entry.title,
                          style: TextStyle(
                            fontFamily: settings.titleFontFamily == 'System'
                                ? null
                                : settings.titleFontFamily,
                            color: Colors.white,
                            fontSize: settings.titleFontSize,
                            fontWeight: settings.titleFontWeight,
                            shadows: const [
                              Shadow(blurRadius: 4, color: Colors.black45),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
