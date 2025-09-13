// Project Imports
// filepath: e:\dev\workspace\dart\sdt\lib\features\settings\domain\usecases\update_count_today.dart
import 'package:sdt/features/settings/domain/repos/settings_repo.dart';

class UpdateCountToday {
  final SettingsRepo repo;
  UpdateCountToday(this.repo);

  Future<void> call(bool value) => repo.updateCountToday(value);
}
