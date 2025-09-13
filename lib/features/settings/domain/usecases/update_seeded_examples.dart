// Project Imports
import 'package:sdtpro/features/settings/domain/repos/settings_repo.dart';

class UpdateSeededExamples {
  final SettingsRepo repo;
  UpdateSeededExamples(this.repo);

  Future<void> call(bool value) => repo.updateSeededExamples(value);
}
