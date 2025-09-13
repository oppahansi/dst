// Project Imports
import 'package:sdt/features/settings/domain/entities/settings.dart';
import 'package:sdt/features/settings/domain/repos/settings_repo.dart';

class UpdateDsSortOrder {
  final SettingsRepo repo;
  UpdateDsSortOrder(this.repo);

  Future<void> call(SdtSortOrder order) => repo.updateDsSortOrder(order);
}
