// Project Imports
import 'package:sdtpro/features/days_since/domain/entities/ds_entry.dart';
import 'package:sdtpro/features/days_since/domain/repos/ds_repo.dart';

class GetEntries {
  final DsRepo repository;
  GetEntries(this.repository);

  Future<List<DsEntry>> call() => repository.getEntries();
}
