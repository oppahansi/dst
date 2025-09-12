// Package Imports
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project Imports
import 'package:sdtpro/features/sdt/domain/entities/sdt_entry.dart';
import 'package:sdtpro/features/sdt/view/providers/sdt_usecase_providers.dart';
import 'package:sdtpro/features/settings/view/providers/settings_provider.dart';

part 'sdt_provider.g.dart';

// Existing notifier kept for mutations (not watched by UI lists anymore)
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
    state = await AsyncValue.guard(() async {
      await ref.read(addEntryProvider)(entry);
      // Invalidate filtered lists
      ref.invalidate(dsNotifierProvider);
      ref.invalidate(dtNotifierProvider);
      return ref.read(getEntriesProvider)();
    });
  }

  Future<void> updateEntry(SdtEntry entry) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(updateEntryProvider)(entry);
      // Invalidate filtered lists
      ref.invalidate(dsNotifierProvider);
      ref.invalidate(dtNotifierProvider);
      return ref.read(getEntriesProvider)();
    });
  }

  Future<void> deleteEntry(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(deleteEntryProvider)(id);
      // Invalidate filtered lists
      ref.invalidate(dsNotifierProvider);
      ref.invalidate(dtNotifierProvider);
      return ref.read(getEntriesProvider)();
    });
  }
}

@riverpod
class DsNotifier extends _$DsNotifier {
  @override
  Future<List<SdtEntry>> build() async {
    final getEntries = ref.watch(getEntriesProvider);
    final settings = ref.watch(settingsNotifierProvider);

    // Efficient DB-side filter + sort (today/past)
    return getEntries(
      type: SdtQueryType.since,
      order: settings.dsSortOrder,
      // Optional: you can pass limit/offset for real paging
    );
  }
}

@riverpod
class DtNotifier extends _$DtNotifier {
  @override
  Future<List<SdtEntry>> build() async {
    final getEntries = ref.watch(getEntriesProvider);
    final settings = ref.watch(settingsNotifierProvider);

    // Efficient DB-side filter + sort (future)
    return getEntries(
      type: SdtQueryType.to,
      order: settings.dtSortOrder,
      // Optional: you can pass limit/offset for real paging
    );
  }
}
