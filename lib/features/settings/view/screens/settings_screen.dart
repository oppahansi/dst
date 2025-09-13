// Package Imports
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

// Project Imports
import "package:sdtpro/core/utils/colors.dart";
import "package:sdtpro/core/utils/extensions.dart";
import "package:sdtpro/core/utils/text_styles.dart";
import "package:sdtpro/features/settings/view/widgets/count_today_setting.dart";
import "package:sdtpro/features/settings/view/widgets/ds_order_setting.dart";
import "package:sdtpro/features/settings/view/widgets/dt_order_setting.dart";
import "package:sdtpro/features/settings/view/widgets/ex_import_setting.dart";
import "package:sdtpro/features/settings/view/widgets/language_setting.dart";
import "package:sdtpro/features/settings/view/widgets/theme_setting.dart";
import "package:sdtpro/l10n/app_localizations.dart";
import 'package:sdtpro/features/settings/view/widgets/count_last_day_setting.dart';
import 'package:sdtpro/features/settings/view/providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const String path = "/settings";

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              loc.settings.capitalize(),
              style: titleMedium(context).withColor(primaryColor(context)),
            ),
            const LanguageSetting(),
            const ThemeSetting(),
            const Divider(),
            const DsOrderSetting(),
            const DtOrderSetting(),
            const CountTodaySetting(),
            const CountLastDaySetting(),
            const Divider(),
            const _ResetSettingsTile(),
            const Divider(),
            const ExImportSetting(),
          ],
        ),
      ),
    );
  }
}

class _ResetSettingsTile extends ConsumerWidget {
  const _ResetSettingsTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;

    return ListTile(
      leading: const Icon(Symbols.restart_alt),
      title: Text(loc.reset_to_defaults),
      subtitle: Text(loc.reset_all_settings_question),
      trailing: const Icon(Symbols.chevron_right),
      onTap: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(loc.reset_to_defaults),
            content: Text(loc.reset_all_settings_question),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(loc.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(loc.reset),
              ),
            ],
          ),
        );
        if (confirmed == true) {
          await ref.read(settingsNotifierProvider.notifier).resetToDefaults();
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(loc.settings_reset_success)));
          }
        }
      },
    );
  }
}
