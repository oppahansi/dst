// Project Imports
import 'package:sdtpro/features/sdt/domain/entities/sdt_entry.dart';
import 'package:sdtpro/features/sdt/domain/repos/sdt_repo.dart';

class UpdateSdtEntry {
  final SdtRepo repository;
  UpdateSdtEntry(this.repository);

  Future<void> call(SdtEntry entry) => repository.updateEntry(entry);
}
