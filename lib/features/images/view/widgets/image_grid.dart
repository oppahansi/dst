// Flutter Imports
import 'package:flutter/material.dart';

// Package Imports
import 'package:material_symbols_icons/symbols.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';

// Project Imports
import 'package:sdt/core/utils/extensions.dart';
import 'package:sdt/features/images/domain/entities/fis_image.dart';
import 'package:sdt/features/images/view/screens/image_preview_screen.dart';
import 'package:sdt/features/images/view/widgets/source_logo.dart';
import 'package:sdt/l10n/app_localizations.dart';

class ImageGrid extends StatelessWidget {
  final List<FisImage> images;
  const ImageGrid({super.key, required this.images});

  Future<void> _launchUrl(BuildContext context, String? urlString) async {
    if (urlString == null) return;
    final url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.could_not_launch_url(url.toString()),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      itemCount: images.length,
      itemBuilder: (context, index) {
        final image = images[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: image.preview,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator.adaptive()),
                errorWidget: (context, url, error) {
                  debugPrint('Image load error: $error');

                  return Center(
                    child: Column(
                      children: [
                        Text(
                          error.toString(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        Icon(
                          Symbols.broken_image,
                          size: 48,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ],
                    ),
                  );
                },
              ),
              // Top overlay for attribution
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black.withAlpha(150), Colors.transparent],
                    ),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      if (image.source != null)
                        InkWell(
                          onTap: () => _launchUrl(context, image.source),
                          child: SourceLogo(source: image.source, height: 16),
                        ),
                      const SizedBox(width: 8),
                      if (image.photographer != null)
                        Expanded(
                          child: InkWell(
                            onTap: () =>
                                _launchUrl(context, image.photographer),
                            child: Text(
                              // A simple heuristic to get a name from a URL
                              image.photographer!.split('/').last,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                shadows: [Shadow(blurRadius: 2)],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black.withAlpha(100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Symbols.fullscreen),
                        color: Colors.white,
                        tooltip: loc.preview,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ImagePreviewScreen(image: image),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Symbols.check_circle),
                        color: Colors.white,
                        tooltip: loc.select,
                        onPressed: () => context.pop(image.preview),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
