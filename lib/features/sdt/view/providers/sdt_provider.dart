// Package Imports
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project Imports
import 'package:sdt/features/sdt/domain/entities/sdt_entry.dart';
import 'package:sdt/features/sdt/view/providers/sdt_usecase_providers.dart';
import 'package:sdt/features/settings/view/providers/settings_provider.dart';
import 'package:sdt/features/sdt/view/providers/sdt_seed_provider.dart';

// NEW
part 'sdt_provider.g.dart';

// Days Since (today or past), DB-filtered and sorted by user settings
@riverpod
class DsNotifier extends _$DsNotifier {
  @override
  Future<List<SdtEntry>> build() async {
    await ref.watch(seedExamplesIfNeededProvider.future);

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
    await ref.watch(seedExamplesIfNeededProvider.future);

    final getEntries = ref.watch(getEntriesProvider);
    final settings = ref.watch(settingsNotifierProvider);
    return getEntries(type: SdtQueryType.to, order: settings.dtSortOrder);
  }
}
