// Project Imports
import 'package:sdtpro/features/days_since/domain/entities/ds_entry.dart';

abstract class DsRepo {
  Future<List<DsEntry>> getEntries();
  Future<DsEntry> addEntry(DsEntry entry);
  Future<void> updateEntry(DsEntry entry);
  Future<void> deleteEntry(int id);
}
