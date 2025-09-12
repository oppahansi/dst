// Project Imports
import 'package:sdtpro/features/days_since/domain/repos/ds_repo.dart';

class DeleteEntry {
  final DsRepo repository;
  DeleteEntry(this.repository);

  Future<void> call(int id) => repository.deleteEntry(id);
}
