// Project Imports
import 'package:sdtpro/features/settings/domain/repos/settings_repo.dart';

class UpdateCountLastDay {
  final SettingsRepo repo;
  UpdateCountLastDay(this.repo);

  Future<void> call(bool value) => repo.updateCountLastDay(value);
}