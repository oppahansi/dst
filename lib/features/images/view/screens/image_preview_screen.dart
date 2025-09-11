// Flutter Imports
import 'package:flutter/material.dart';

// Package Imports
import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:url_launcher/url_launcher.dart';

// Project Imports
import 'package:sdtpro/features/images/domain/entities/fis_image.dart';
import 'package:sdtpro/features/images/view/widgets/source_logo.dart';
import 'package:sdtpro/l10n/app_localizations.dart';

class ImagePreviewScreen extends StatefulWidget {
  final FisImage image;

  const ImagePreviewScreen({super.key, required this.image});

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  bool _showOverlay = true;

  Future<void> _launchUrl(String? urlString) async {
    if (urlString == null) return;
    final url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(
                context,
              )!.could_not_launch_url(url.toString()),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: _showOverlay
            ? Colors.black.withAlpha(100)
            : Colors.transparent,
        elevation: 0,
        actions: [
          if (_showOverlay && widget.image.source != null)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: InkWell(
                onTap: () => _launchUrl(widget.image.source),
                child: SourceLogo(source: widget.image.source),
              ),
            ),
        ],
      ),
      body: GestureDetector(
        onTap: () => setState(() => _showOverlay = !_showOverlay),
        child: Stack(
          fit: StackFit.expand,
          children: [
            InteractiveViewer(
              child: CachedNetworkImage(
                imageUrl: widget.image.preview,
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator.adaptive()),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error, color: Colors.white),
              ),
            ),
            if (_showOverlay)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildInfoOverlay(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoOverlay() {
    final loc = AppLocalizations.of(context)!;
    // Use a SafeArea to avoid system intrusions at the bottom.
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.black.withAlpha(100),
        child: Row(
          children: [
            if (widget.image.photographer != null)
              Expanded(
                child: InkWell(
                  onTap: () => _launchUrl(widget.image.photographer),
                  child: Text(
                    // A simple heuristic to get a name from a URL
                    widget.image.photographer!.split('/').last,
                    style: const TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            const Spacer(),
            if (widget.image.license != null)
              IconButton(
                icon: const Icon(Symbols.copyright),
                color: Colors.white,
                tooltip: loc.view_license,
                onPressed: () => _launchUrl(widget.image.license),
              ),
            // Only show the dedicated link button if it's different from the source link
            if (widget.image.url != widget.image.source)
              IconButton(
                icon: const Icon(Symbols.open_in_new),
                color: Colors.white,
                tooltip: loc.view_on_source_page,
                onPressed: () => _launchUrl(widget.image.url),
              ),
          ],
        ),
      ),
    );
  }
}
