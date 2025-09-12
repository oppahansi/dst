// Dart Imports
import 'dart:io';

// Flutter Imports
import 'package:flutter/material.dart';

// Package Imports
import 'package:cached_network_image/cached_network_image.dart';

class StylizedDsBackgroundImage extends StatelessWidget {
  final String? imageUrl;

  const StylizedDsBackgroundImage({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final String? localImageUrl = imageUrl;
    if (localImageUrl == null || localImageUrl.isEmpty) {
      return Container(color: Theme.of(context).colorScheme.surfaceDim);
    }

    if (localImageUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: localImageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    } else {
      return Image.file(
        File(localImageUrl),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
      );
    }
  }
}
