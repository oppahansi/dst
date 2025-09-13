// Project Imports
import 'package:sdt/features/sdt/domain/entities/sdt_entry.dart';

abstract class SdtRepo {
  Future<List<SdtEntry>> getEntries();

  Future<List<SdtEntry>> getEntriesFiltered({
    required SdtQueryType type,
    required bool ascending,
    int? limit,
    int? offset,
  });

  Future<SdtEntry> addEntry(SdtEntry entry);
  Future<void> updateEntry(SdtEntry entry);
  Future<void> deleteEntry(int id);
}
