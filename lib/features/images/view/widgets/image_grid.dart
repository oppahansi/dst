// Flutter Imports
import 'package:flutter/material.dart';

// Package Imports
import 'package:material_symbols_icons/symbols.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// Project Imports
import 'package:sdtpro/core/utils/extensions.dart';
import 'package:sdtpro/features/images/domain/entities/fis_image.dart';
import 'package:sdtpro/features/images/view/screens/image_preview_screen.dart';
import 'package:sdtpro/l10n/app_localizations.dart';

class ImageGrid extends StatelessWidget {
  final List<FisImage> images;
  const ImageGrid({super.key, required this.images});

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
                errorWidget: (context, url, error) => const Icon(Icons.error),
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
