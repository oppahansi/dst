// Project Imports
import 'package:sdtpro/features/settings/domain/entities/settings.dart';
import 'package:sdtpro/features/settings/domain/repos/settings_repo.dart';

class UpdateDtSortOrder {
  final SettingsRepo repo;
  UpdateDtSortOrder(this.repo);

  Future<void> call(SdtSortOrder order) => repo.updateDtSortOrder(order);
}
