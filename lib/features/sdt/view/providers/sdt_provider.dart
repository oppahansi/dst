// Package Imports
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project Imports
import 'package:sdtpro/features/sdt/domain/entities/sdt_entry.dart';
import 'package:sdtpro/features/sdt/view/providers/sdt_usecase_providers.dart';
import 'package:sdtpro/features/settings/view/providers/settings_provider.dart';

part 'sdt_provider.g.dart';

// Existing notifier kept for mutations (not watched by UI lists anymore)
// Make it keepAlive so it doesn't dispose mid-mutation
@riverpod
class SdtNotifier extends _$SdtNotifier {
  @override
  Future<List<SdtEntry>> build() async {
    // Keep as-is for mutations; list UIs use filtered notifiers.
    final getEntries = ref.watch(getEntriesProvider);
    final entries = await getEntries(); // back-compat (unfiltered)
    if (entries.isEmpty) {
      await ref.read(addEntryProvider)(
        SdtEntry(
          title: 'Example Title',
          date: DateTime.now().subtract(const Duration(days: 128)),
          imageUrl:
              'https://images.unsplash.com/photo-1506905925346-21bda4d32df4',
        ),
      );
      return ref.read(getEntriesProvider)();
    }
    return entries;
  }

  Future<void> addEntry(SdtEntry entry) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(addEntryProvider)(entry);
      if (!ref.mounted) return;
      // Invalidate filtered lists
      ref.invalidate(dsNotifierProvider);
      ref.invalidate(dtNotifierProvider);
      // No need to refetch all entries here; this notifier isn't used for lists
      state = AsyncValue.data(state.value ?? const []);
    } catch (e, st) {
      if (!ref.mounted) return;
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateEntry(SdtEntry entry) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(updateEntryProvider)(entry);
      if (!ref.mounted) return;
      ref.invalidate(dsNotifierProvider);
      ref.invalidate(dtNotifierProvider);
      state = AsyncValue.data(state.value ?? const []);
    } catch (e, st) {
      if (!ref.mounted) return;
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteEntry(int id) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(deleteEntryProvider)(id);
      if (!ref.mounted) return;
      ref.invalidate(dsNotifierProvider);
      ref.invalidate(dtNotifierProvider);
      state = AsyncValue.data(state.value ?? const []);
    } catch (e, st) {
      if (!ref.mounted) return;
      state = AsyncValue.error(e, st);
    }
  }
}

// Days Since (today or past), DB-filtered and sorted by user settings
@riverpod
class DsNotifier extends _$DsNotifier {
  @override
  Future<List<SdtEntry>> build() async {
    final getEntries = ref.watch(getEntriesProvider);
    final settings = ref.watch(settingsNotifierProvider);
    return getEntries(type: SdtQueryType.since, order: settings.dsSortOrder);
  }
}

// Days To (future), DB-filtered and sorted by user settings
@riverpod
class DtNotifier extends _$DtNotifier {
  @override
  Future<List<SdtEntry>> build() async {
    final getEntries = ref.watch(getEntriesProvider);
    final settings = ref.watch(settingsNotifierProvider);
    return getEntries(type: SdtQueryType.to, order: settings.dtSortOrder);
  }
}
