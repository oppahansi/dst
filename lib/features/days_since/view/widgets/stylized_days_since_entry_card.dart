// Flutter Imports
import 'package:flutter/material.dart';

// Package Imports
import 'package:cached_network_image/cached_network_image.dart';

// Project Imports
import 'package:sdtpro/core/utils/text_styles.dart';
import 'package:sdtpro/features/days_since/view/screens/days_since_entry_detail_screen.dart';
import 'package:sdtpro/features/days_since/domain/entities/days_since_entry.dart';
import 'package:sdtpro/l10n/app_localizations.dart';

class StylizedDaysSinceEntryCard extends StatelessWidget {
  final DaysSinceEntry entry;
  const StylizedDaysSinceEntryCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final days = DateTime.now().difference(entry.date).inDays;
    final loc = AppLocalizations.of(context)!;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DaysSinceEntryDetailScreen(entry: entry),
            ),
          );
        },
        child: AspectRatio(
          aspectRatio: 16 / 10,
          child: Stack(
            children: [
              // Background Image
              if (entry.imageUrl != null)
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: entry.imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              // Gradient Overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '$days',
                      style: displayMedium(
                        context,
                      )?.copyWith(color: Colors.white),
                    ),
                    Text(
                      loc.days_since_title(entry.title),
                      style: titleLarge(context)?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
