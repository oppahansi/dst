// Project Imports
import 'package:sdtpro/features/sdt/domain/entities/sdt_entry.dart';
import 'package:sdtpro/features/sdt/domain/repos/sdt_repo.dart';

class AddSdtEntry {
  final SdtRepo repository;
  AddSdtEntry(this.repository);

  Future<SdtEntry> call(SdtEntry entry) => repository.addEntry(entry);
}
