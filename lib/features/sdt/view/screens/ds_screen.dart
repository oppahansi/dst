// Package Imports
import "package:exui/exui.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_riverpod/legacy.dart";
import "package:material_symbols_icons/symbols.dart";

// Project Imports
import "package:sdt/core/widgets/debug_settings_controlls.dart";
import "package:sdt/features/sdt/view/providers/sdt_provider.dart";
import "package:sdt/features/sdt/view/widgets/ds_card.dart";
import "package:sdt/l10n/app_localizations.dart";

// Visible count for Days Since
final dsVisibleCountProvider = StateProvider<int>((ref) => 10);

class DsScreen extends ConsumerWidget {
  const DsScreen({super.key});

  static const String path = "/dayssince";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    // CHANGED: use since-only provider
    final daysSinceState = ref.watch(dsNotifierProvider);
    final visibleCount = ref.watch(dsVisibleCountProvider);

    return daysSinceState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('${loc.error}: $err')),
      data: (entries) {
        // entries already filtered (past/today) and sorted by user settings
        final visible = entries.take(visibleCount).toList();
        final hasMore = visible.length < entries.length;

        final hasDebug = kDebugMode;
        final base = hasDebug ? 1 : 0;
        final itemCount = visible.length + base + (hasMore ? 1 : 0);

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            if (hasDebug && index == 0) {
              return const DebugSettingsControlls();
            }
            final localIndex = index - base;

            if (hasMore && localIndex == visible.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: OutlinedButton.icon(
                  onPressed: () =>
                      ref.read(dsVisibleCountProvider.notifier).state =
                          visibleCount + 10,
                  icon: const Icon(Symbols.downloading),
                  label: Text(loc.load_more),
                ),
              );
            }

            final entry = visible[localIndex];
            return SdtCard(entry: entry).marginVertical(8);
          },
        );
      },
    );
  }
}
