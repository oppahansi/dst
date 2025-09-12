// Project Imports
import 'package:sdtpro/features/sdt/domain/entities/sdt_entry.dart';
import 'package:sdtpro/features/sdt/domain/repos/sdt_repo.dart';
import 'package:sdtpro/features/settings/domain/entities/settings.dart';

class GetSdtEntries {
  final SdtRepo repository;
  GetSdtEntries(this.repository);

  Future<List<SdtEntry>> call({
    SdtQueryType? type,
    SdtSortOrder? order,
    int? limit,
    int? offset,
  }) {
    if (type == null || order == null) {
      // Back-compat path
      return repository.getEntries();
    }

    // Map UI sort order to SQL date order:
    // - Since: asc (small days->big) => date DESC; desc => date ASC
    // - To:    asc (soon->far) => date ASC;      desc => date DESC
    final bool ascendingDate = switch (type) {
      SdtQueryType.since => order == SdtSortOrder.desc,
      SdtQueryType.to => order == SdtSortOrder.asc,
    };

    return repository.getEntriesFiltered(
      type: type,
      ascending: ascendingDate,
      limit: limit,
      offset: offset,
    );
  }
}
