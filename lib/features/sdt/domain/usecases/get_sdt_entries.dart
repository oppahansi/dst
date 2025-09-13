// Project Imports
// REMOVE seeding and randomization here; keep only filtering logic
// import 'dart:math'; // removed
// import 'package:flutter/material.dart'; // removed
import 'package:sdtpro/features/sdt/domain/entities/sdt_entry.dart';
import 'package:sdtpro/features/sdt/domain/repos/sdt_repo.dart';
import 'package:sdtpro/features/settings/domain/entities/settings.dart';
// import 'package:sdtpro/features/sdt/domain/entities/sdt_settings.dart'; // removed

class GetSdtEntries {
  final SdtRepo repository;
  GetSdtEntries(this.repository);

  Future<List<SdtEntry>> call({
    SdtQueryType? type,
    SdtSortOrder? order,
    int? limit,
    int? offset,
  }) async {
    if (type == null || order == null) {
      return repository.getEntries();
    }

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
