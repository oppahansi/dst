// Project Imports
import 'package:sdtpro/features/sdt/domain/entities/sdt_entry.dart';

abstract class SdtRepo {
  Future<List<SdtEntry>> getEntries();
  Future<SdtEntry> addEntry(SdtEntry entry);
  Future<void> updateEntry(SdtEntry entry);
  Future<void> deleteEntry(int id);
}
