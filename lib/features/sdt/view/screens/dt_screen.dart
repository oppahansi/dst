// Package Imports
import "package:exui/exui.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

// Project Imports
import "package:sdtpro/core/widgets/debug_settings_controlls.dart";
import "package:sdtpro/features/sdt/view/providers/sdt_provider.dart";
import "package:sdtpro/features/sdt/view/widgets/ds_card.dart";
import "package:sdtpro/l10n/app_localizations.dart";

class DtScreen extends ConsumerWidget {
  const DtScreen({super.key});

  static const String path = "/daysto";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final state = ref.watch(sdtNotifierProvider);

    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('${loc.error}: $err')),
      data: (entries) {
        final now = DateTime.now();
        final future = entries.where((e) => e.date.isAfter(now)).toList();
        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: future.length + (kDebugMode ? 1 : 0),
          itemBuilder: (context, index) {
            if (kDebugMode && index == 0) {
              return const DebugSettingsControlls();
            }
            final entry = future[index - (kDebugMode ? 1 : 0)];
            return SdtCard(entry: entry).marginVertical(8);
          },
        );
      },
    );
  }
}
