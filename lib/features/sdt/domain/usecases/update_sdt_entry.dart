// Project Imports
import 'package:sdt/features/sdt/domain/entities/sdt_entry.dart';
import 'package:sdt/features/sdt/domain/repos/sdt_repo.dart';

class UpdateSdtEntry {
  final SdtRepo repository;
  UpdateSdtEntry(this.repository);

  Future<void> call(SdtEntry entry) => repository.updateEntry(entry);
}
