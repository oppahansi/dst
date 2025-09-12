// Flutter Imports
import 'package:flutter/material.dart';

// Package Imports
import 'package:intl/intl.dart';

// Project Imports
import 'package:sdtpro/core/utils/text_styles.dart';
import 'package:sdtpro/features/days_since/view/screens/ds_detail_screen.dart';
import 'package:sdtpro/features/days_since/domain/entities/stylized_settings.dart';
import 'package:sdtpro/features/days_since/domain/entities/days_since_entry.dart';
import 'package:sdtpro/l10n/app_localizations.dart';

class SimpleDsTile extends StatelessWidget {
  final DaysSinceEntry entry;
  final bool isTappable;
  const SimpleDsTile({super.key, required this.entry, this.isTappable = true});

  @override
  Widget build(BuildContext context) {
    final days = DateTime.now().difference(entry.date).inDays;
    final loc = AppLocalizations.of(context)!;
    final settings = entry.stylizedSettings ?? StylizedSettings();

    final daysSince = settings.showSubtitleDate
        ? "${loc.days_since} ${DateFormat(settings.subtitleDateFormat, loc.localeName).format(entry.date)}"
        : loc.days_since;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: isTappable
            ? () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DsDetailScreen(entry: entry),
                  ),
                );
              }
            : null,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          title: Row(
            children: [
              Text('$days', style: titleLarge(context)),
              const SizedBox(width: 8),
              Text(daysSince, style: bodySmall(context)),
            ],
          ),
          subtitle: entry.description != null
              ? Text(
                  entry.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [Text(entry.title, style: titleMedium(context))],
          ),
        ),
      ),
    );
  }
}
