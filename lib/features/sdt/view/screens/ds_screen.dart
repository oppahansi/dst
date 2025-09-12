// Package Imports
import "package:exui/exui.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_riverpod/legacy.dart";
import "package:material_symbols_icons/symbols.dart";

// Project Imports
import "package:sdtpro/core/widgets/debug_settings_controlls.dart";
import "package:sdtpro/features/sdt/view/providers/sdt_provider.dart";
import "package:sdtpro/features/sdt/view/widgets/ds_card.dart";
import "package:sdtpro/features/settings/view/providers/settings_provider.dart";
import "package:sdtpro/features/settings/domain/entities/settings.dart";
import "package:sdtpro/l10n/app_localizations.dart";

// Visible count for Days Since
final dsVisibleCountProvider = StateProvider<int>((ref) => 10);

class DsScreen extends ConsumerWidget {
  const DsScreen({super.key});

  static const String path = "/dayssince";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final daysSinceState = ref.watch(sdtNotifierProvider);
    final settings = ref.watch(settingsNotifierProvider);
    final visibleCount = ref.watch(dsVisibleCountProvider);

    return daysSinceState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('${loc.error}: $err')),
      data: (entries) {
        final now = DateTime.now();
        // Past or today
        final all = entries.where((e) => !e.date.isAfter(now)).toList();

        // Sort by days counter (small -> big or big -> small)
        all.sort((a, b) {
          final da = now.difference(a.date).inDays;
          final db = now.difference(b.date).inDays;
          return settings.dsSortOrder == SdtSortOrder.asc
              ? da.compareTo(db)
              : db.compareTo(da);
        });

        final visible = all.take(visibleCount).toList();
        final hasMore = visible.length < all.length;

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

            // Load more button
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
