// Project Imports
import 'package:sdtpro/features/settings/domain/entities/settings.dart';
import 'package:sdtpro/features/settings/domain/repos/settings_repository.dart';

class GetSettings {
  final SettingsRepository repository;

  GetSettings(this.repository);

  Future<Settings> call() => repository.getSettings();
}
