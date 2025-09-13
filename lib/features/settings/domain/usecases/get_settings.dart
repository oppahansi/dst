// Project Imports
import 'package:sdt/features/settings/domain/entities/settings.dart';
import 'package:sdt/features/settings/domain/repos/settings_repo.dart';

class GetSettings {
  final SettingsRepo repository;

  GetSettings(this.repository);

  Future<Settings> call() => repository.getSettings();
}
