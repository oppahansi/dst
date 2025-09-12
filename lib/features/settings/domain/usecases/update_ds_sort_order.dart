// Project Imports
import 'package:sdtpro/features/settings/domain/entities/settings.dart';
import 'package:sdtpro/features/settings/domain/repos/settings_repo.dart';

class UpdateDsSortOrder {
  final SettingsRepo repo;
  UpdateDsSortOrder(this.repo);

  Future<void> call(SdtSortOrder order) => repo.updateDsSortOrder(order);
}
