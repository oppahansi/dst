// Project Imports
import 'package:sdt/features/settings/domain/repos/settings_repo.dart';

class ResetSettings {
  final SettingsRepo repo;
  ResetSettings(this.repo);

  Future<void> call() => repo.resetToDefaults();
}
