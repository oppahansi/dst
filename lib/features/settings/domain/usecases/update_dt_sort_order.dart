// Project Imports
import 'package:sdt/features/settings/domain/entities/settings.dart';
import 'package:sdt/features/settings/domain/repos/settings_repo.dart';

class UpdateDtSortOrder {
  final SettingsRepo repo;
  UpdateDtSortOrder(this.repo);

  Future<void> call(SdtSortOrder order) => repo.updateDtSortOrder(order);
}
