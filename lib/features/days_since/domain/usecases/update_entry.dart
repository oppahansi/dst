// Project Imports
import 'package:sdtpro/features/days_since/domain/entities/ds_entry.dart';
import 'package:sdtpro/features/days_since/domain/repos/ds_repo.dart';

class UpdateEntry {
  final DsRepo repository;
  UpdateEntry(this.repository);

  Future<void> call(DsEntry entry) => repository.updateEntry(entry);
}
