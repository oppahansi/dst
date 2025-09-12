// Project Imports
import 'package:sdtpro/features/sdt/domain/repos/sdt_repo.dart';

class DeleteSdtEntry {
  final SdtRepo repository;
  DeleteSdtEntry(this.repository);

  Future<void> call(int id) => repository.deleteEntry(id);
}
