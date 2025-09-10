// Flutter Imports
import 'package:flutter/material.dart';

// Project Imports
import 'package:sdtpro/core/utils/text_styles.dart';
import 'package:sdtpro/features/days_since/view/screens/days_since_entry_detail_screen.dart';
import 'package:sdtpro/features/days_since/domain/entities/days_since_entry.dart';
import 'package:sdtpro/l10n/app_localizations.dart';

class SimpleDaysSinceEntryTile extends StatelessWidget {
  final DaysSinceEntry entry;
  const SimpleDaysSinceEntryTile({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final days = DateTime.now().difference(entry.date).inDays;
    final loc = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DaysSinceEntryDetailScreen(entry: entry),
            ),
          );
        },
        child: ListTile(
          title: Text(entry.title, style: titleMedium(context)),
          subtitle: entry.description != null
              ? Text(
                  entry.description!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          trailing: Text('$days ${loc.days}', style: headlineSmall(context)),
        ),
      ),
    );
  }
}
