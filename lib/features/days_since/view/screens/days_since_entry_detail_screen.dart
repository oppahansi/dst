// Flutter Imports
// Flutter imports
import 'package:flutter/material.dart';

// Package Imports
// Package imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

// Project Imports
// Project imports
import 'package:sdtpro/core/utils/extensions.dart';
import 'package:sdtpro/features/days_since/domain/entities/days_since_entry.dart';
import 'package:sdtpro/features/days_since/view/providers/days_since_provider.dart';
import 'package:sdtpro/features/days_since/view/widgets/edit_days_since_entry_sheet.dart';
import 'package:sdtpro/features/days_since/view/widgets/stylized_days_since_entry_card.dart';
import 'package:sdtpro/l10n/app_localizations.dart';

class DaysSinceEntryDetailScreen extends ConsumerWidget {
  final DaysSinceEntry entry;

  const DaysSinceEntryDetailScreen({super.key, required this.entry});

  void _showEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => EditDaysSinceEntrySheet(entry: entry),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final loc = AppLocalizations.of(context)!;
    final didConfirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.delete_entry_title),
        content: Text(loc.delete_entry_confirmation),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: Text(loc.cancel),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(loc.delete),
          ),
        ],
      ),
    );

    if (didConfirm == true && context.mounted) {
      await ref.read(daysSinceNotifierProvider.notifier).deleteEntry(entry.id!);
      context.pop(); // Close the detail screen
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(entry.title),
        actions: [
          IconButton(
            icon: const Icon(Symbols.edit),
            tooltip: loc.edit,
            onPressed: () => _showEditSheet(context),
          ),
          IconButton(
            icon: const Icon(Symbols.delete),
            tooltip: loc.delete,
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We can reuse the stylized card for a nice visual header
            StylizedDaysSinceEntryCard(entry: entry),
            const SizedBox(height: 24),
            if (entry.description != null && entry.description!.isNotEmpty)
              Text(
                loc.description,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            if (entry.description != null && entry.description!.isNotEmpty)
              const SizedBox(height: 8),
            if (entry.description != null && entry.description!.isNotEmpty)
              Text(
                entry.description!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
          ],
        ),
      ),
    );
  }
}
