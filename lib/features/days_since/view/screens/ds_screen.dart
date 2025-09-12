// Package Imports
import "package:exui/exui.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

// Project Imports
import "package:sdtpro/features/days_since/view/providers/days_since_provider.dart";
import "package:sdtpro/features/days_since/view/widgets/stylized_ds_card.dart";
import "package:sdtpro/core/widgets/debug_settings_controlls.dart";
import "package:sdtpro/l10n/app_localizations.dart";

class DsScreen extends ConsumerWidget {
  const DsScreen({super.key});

  static const String path = "/dayssince";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final daysSinceState = ref.watch(daysSinceNotifierProvider);

    return daysSinceState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('${loc.error}: $err')),
      data: (entries) {
        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: entries.length + (kDebugMode ? 1 : 0),
          itemBuilder: (context, index) {
            if (kDebugMode && index == 0) {
              return const DebugSettingsControlls();
            }
            final entry = entries[index - (kDebugMode ? 1 : 0)];

            return DsCard(entry: entry).marginVertical(8);
          },
        );
      },
    );
  }
}
