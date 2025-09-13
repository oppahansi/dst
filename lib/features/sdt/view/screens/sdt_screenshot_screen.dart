// Dart Imports
import 'dart:io';

// Flutter Imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package Imports
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

// Project Imports
import 'package:sdt/features/sdt/view/widgets/ds_background_image.dart';
import 'package:sdt/features/sdt/view/widgets/ds_content.dart';
import 'package:sdt/core/utils/extensions.dart';
import 'package:sdt/features/sdt/domain/entities/sdt_entry.dart';
import 'package:sdt/features/sdt/domain/entities/sdt_settings.dart';
import 'package:sdt/l10n/app_localizations.dart';

class SdtScreenshotScreen extends StatefulWidget {
  final SdtEntry entry;

  const SdtScreenshotScreen({super.key, required this.entry});

  @override
  State<SdtScreenshotScreen> createState() => _SdtScreenshotScreenState();
}

class _SdtScreenshotScreenState extends State<SdtScreenshotScreen> {
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
    final loc = AppLocalizations.of(context)!;
    final settings = widget.entry.settings ?? SdtSettings();

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
              SdtBackgroundImage(imageUrl: widget.entry.imageUrl),

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
                child: SdtContent(
                  entry: widget.entry,
                  settings: settings,
                  contentContext: SdtContentContext.fullscreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
