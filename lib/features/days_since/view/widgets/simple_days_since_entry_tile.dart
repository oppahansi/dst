// Flutter Imports
import 'package:flutter/material.dart';

// Package Imports
import 'package:intl/intl.dart';

// Project Imports
import 'package:sdtpro/core/utils/text_styles.dart';
import 'package:sdtpro/features/days_since/view/screens/days_since_entry_detail_screen.dart';
import 'package:sdtpro/features/days_since/domain/entities/days_since_entry.dart';
import 'package:sdtpro/l10n/app_localizations.dart';

class SimpleDaysSinceEntryTile extends StatelessWidget {
  final DaysSinceEntry entry;
  final bool isTappable;
  const SimpleDaysSinceEntryTile({
    super.key,
    required this.entry,
    this.isTappable = true,
  });

  @override
  Widget build(BuildContext context) {
    final days = DateTime.now().difference(entry.date).inDays;
    final loc = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: isTappable
            ? () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        DaysSinceEntryDetailScreen(entry: entry),
                  ),
                );
              }
            : null,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          title: Text(entry.title, style: titleMedium(context)),
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
            children: [
              Text('$days ${loc.days}', style: titleMedium(context)),
              Text(
                loc.since_date(
                  DateFormat.yMMMd(loc.localeName).format(entry.date),
                ),
                style: bodySmall(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
