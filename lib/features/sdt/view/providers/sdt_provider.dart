// Package Imports
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project Imports
import 'package:sdtpro/features/sdt/domain/entities/sdt_entry.dart';
import 'package:sdtpro/features/sdt/view/providers/sdt_usecase_providers.dart';

part 'sdt_provider.g.dart';

@riverpod
class SdtNotifier extends _$SdtNotifier {
  @override
  Future<List<SdtEntry>> build() async {
    final getEntries = ref.watch(getEntriesProvider);
    final entries = await getEntries();
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
      return ref.read(getEntriesProvider)();
    });
  }

  Future<void> updateEntry(SdtEntry entry) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(updateEntryProvider)(entry);
      return ref.read(getEntriesProvider)();
    });
  }

  Future<void> deleteEntry(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(deleteEntryProvider)(id);
      return ref.read(getEntriesProvider)();
    });
  }
}
