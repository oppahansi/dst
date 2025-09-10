// Project Imports
import 'package:sdtpro/features/days_since/domain/entities/days_since_entry.dart';

abstract class DaysSinceRepository {
  Future<List<DaysSinceEntry>> getEntries();
  Future<DaysSinceEntry> addEntry(DaysSinceEntry entry);
  Future<void> updateEntry(DaysSinceEntry entry);
  Future<void> deleteEntry(int id);
}
