// Dart Imports
import 'dart:io';

// Flutter Imports
import 'package:flutter/material.dart';

// Package Imports
import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

// Project Imports
import 'package:sdtpro/features/days_since/view/screens/days_since_entry_detail_screen.dart';
import 'package:sdtpro/features/days_since/domain/entities/days_since_entry.dart';
import 'package:sdtpro/features/days_since/domain/entities/stylized_settings.dart';
import 'package:sdtpro/l10n/app_localizations.dart';

class StylizedDaysSinceEntryCard extends StatefulWidget {
  final DaysSinceEntry entry;
  final bool isTappable;
  const StylizedDaysSinceEntryCard({
    super.key,
    required this.entry,
    this.isTappable = true,
  });

  @override
  State<StylizedDaysSinceEntryCard> createState() =>
      _StylizedDaysSinceEntryCardState();
}

class _StylizedDaysSinceEntryCardState
    extends State<StylizedDaysSinceEntryCard> {
  final _screenshotController = ScreenshotController();

  Future<void> _captureAndShareScreenshot() async {
    final loc = AppLocalizations.of(context)!;
    // We use `captureFromLongWidget` to render the full-screen content off-screen.
    final imageBytes = await _screenshotController.captureFromLongWidget(
      _buildScreenshotContent(context),
      pixelRatio: MediaQuery.of(context).devicePixelRatio * 2,
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
  Widget _buildScreenshotContent(BuildContext context) {
    final days = DateTime.now().difference(widget.entry.date).inDays;
    final loc = AppLocalizations.of(context)!;
    final settings = widget.entry.stylizedSettings ?? StylizedSettings();

    return RepaintBoundary(
      child: Material(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            if (widget.entry.imageUrl != null &&
                widget.entry.imageUrl!.isNotEmpty) ...[
              if (widget.entry.imageUrl!.startsWith('http'))
                CachedNetworkImage(
                  imageUrl: widget.entry.imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
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
            Center(
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
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final days = DateTime.now().difference(widget.entry.date).inDays;
    final settings = widget.entry.stylizedSettings ?? StylizedSettings();
    final hasImage =
        widget.entry.imageUrl != null && widget.entry.imageUrl!.isNotEmpty;
    final loc = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        child: Screenshot(
          controller: _screenshotController,
          child: InkWell(
            onTap: widget.isTappable
                ? () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            DaysSinceEntryDetailScreen(entry: widget.entry),
                      ),
                    );
                  }
                : null,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image (handles both network and local files)
                  if (hasImage) ...[
                    if (widget.entry.imageUrl!.startsWith('http'))
                      CachedNetworkImage(
                        imageUrl: widget.entry.imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Symbols.error),
                      )
                    else
                      Image.file(
                        File(widget.entry.imageUrl!),
                        fit: BoxFit.cover,
                      ),
                  ] else
                    Container(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                    ),

                  // Overlay
                  Container(
                    color: settings.overlayColor.withAlpha(
                      (settings.overlayAlpha * 255).round(),
                    ),
                  ),

                  // Icon in top right corner
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(
                      settings.icon,
                      color: Colors.white,
                      size: 24,
                      shadows: const [
                        Shadow(blurRadius: 4, color: Colors.black54),
                      ],
                    ),
                  ),

                  // Share button in bottom right corner
                  if (widget.isTappable)
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: IconButton(
                        icon: const Icon(Symbols.share),
                        color: Colors.white,
                        tooltip: loc.share,
                        onPressed: _captureAndShareScreenshot,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black.withAlpha(50),
                        ),
                      ),
                    ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '$days',
                              style: TextStyle(
                                fontFamily: settings.daysFontFamily == 'System'
                                    ? null
                                    : settings.daysFontFamily,
                                fontSize:
                                    40, // A smaller size for the card view
                                color: Colors.white,
                                fontWeight: settings.daysFontWeight,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              loc.days_since,
                              style: TextStyle(
                                fontFamily:
                                    settings.subtitleFontFamily == 'System'
                                    ? null
                                    : settings.subtitleFontFamily,
                                fontSize: 16,
                                color: Colors.white.withAlpha(200),
                                fontWeight: settings.subtitleFontWeight,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.entry.title,
                          style: TextStyle(
                            fontFamily: settings.titleFontFamily == 'System'
                                ? null
                                : settings.titleFontFamily,
                            fontSize: 18, // A smaller size for the card view
                            color: Colors.white,
                            fontWeight: settings.titleFontWeight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
