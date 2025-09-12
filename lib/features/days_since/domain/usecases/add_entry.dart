// Project Imports
import 'package:sdtpro/features/days_since/domain/entities/ds_entry.dart';
import 'package:sdtpro/features/days_since/domain/repos/ds_repo.dart';

class AddEntry {
  final DsRepo repository;
  AddEntry(this.repository);

  Future<DsEntry> call(DsEntry entry) => repository.addEntry(entry);
}
