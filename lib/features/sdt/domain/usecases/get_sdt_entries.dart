// Project Imports
import 'package:sdtpro/features/sdt/domain/entities/sdt_entry.dart';
import 'package:sdtpro/features/sdt/domain/repos/sdt_repo.dart';

class GetSdtEntries {
  final SdtRepo repository;
  GetSdtEntries(this.repository);

  Future<List<SdtEntry>> call() => repository.getEntries();
}
