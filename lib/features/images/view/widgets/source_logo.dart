// Flutter Imports
import 'package:flutter/material.dart';

// Package Imports
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_symbols_icons/symbols.dart';

class SourceLogo extends StatelessWidget {
  final String? source;
  final double height;
  final Color color;

  const SourceLogo({
    super.key,
    required this.source,
    this.height = 20,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    if (source == null) return const SizedBox.shrink();

    final String lowerCaseSource = source!.toLowerCase();
    String? assetName;

    if (lowerCaseSource.contains('pexels')) {
      assetName = 'assets/logos/pexels.svg';
    } else if (lowerCaseSource.contains('pixabay')) {
      assetName = 'assets/logos/pixabay.svg';
    } else if (lowerCaseSource.contains('unsplash')) {
      assetName = 'assets/logos/unsplash.svg';
    }

    if (assetName != null) {
      return SvgPicture.asset(
        assetName,
        height: height,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    }

    return Icon(Symbols.public, color: color, size: height);
  }
}
