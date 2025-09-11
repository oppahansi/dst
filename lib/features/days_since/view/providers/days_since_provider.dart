// Package Imports
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project Imports
import 'package:sdtpro/features/days_since/data/days_since_repository_impl.dart';
import 'package:sdtpro/features/days_since/domain/entities/days_since_entry.dart';
import 'package:sdtpro/features/days_since/domain/repos/days_since_repository.dart';

part 'days_since_provider.g.dart';

@riverpod
DaysSinceRepository daysSinceRepository(Ref ref) {
  return DaysSinceRepositoryImpl();
}

@riverpod
class DaysSinceNotifier extends _$DaysSinceNotifier {
  @override
  Future<List<DaysSinceEntry>> build() async {
    // For demonstration, I'll add some mock data on first load if the list is empty.
    // In a real scenario, you'd likely just fetch.
    final repo = ref.watch(daysSinceRepositoryProvider);
    final entries = await repo.getEntries();
    if (entries.isEmpty) {
      await repo.addEntry(
        DaysSinceEntry(
          title: 'Simple Style Example',
          date: DateTime.now().subtract(const Duration(days: 42)),
          description: 'The beginning of a beautiful journey.',
          displayMode: DaysSinceDisplayMode.simple,
        ),
      );
      await repo.addEntry(
        DaysSinceEntry(
          title: 'Stylized Style Example',
          date: DateTime.now().subtract(const Duration(days: 128)),
          imageUrl:
              'https://images.unsplash.com/photo-1506905925346-21bda4d32df4',
          displayMode: DaysSinceDisplayMode.stylized,
        ),
      );
      return repo.getEntries();
    }
    return entries;
  }

  Future<void> addEntry(DaysSinceEntry entry) async {
    final repo = ref.read(daysSinceRepositoryProvider);
    // Set the state to loading to show a spinner while adding
    state = const AsyncValue.loading();
    // Use a try-catch block to handle potential errors
    state = await AsyncValue.guard(() async {
      await repo.addEntry(entry);
      return repo.getEntries(); // Refetch the list to include the new item
    });
  }

  Future<void> updateEntry(DaysSinceEntry entry) async {
    final repo = ref.read(daysSinceRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repo.updateEntry(entry);
      return repo.getEntries();
    });
  }

  Future<void> deleteEntry(int id) async {
    final repo = ref.read(daysSinceRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repo.deleteEntry(id);
      return repo.getEntries();
    });
  }
}
