// Package Imports
import "package:flutter/material.dart";
import "package:material_symbols_icons/symbols.dart";

// Project Imports
import "package:sdt/core/utils/colors.dart";
import "package:sdt/core/utils/extensions.dart";
import "package:sdt/core/utils/native_backup.dart";
import "package:sdt/core/utils/screen_sizes.dart";
import "package:sdt/core/utils/text_styles.dart";
import "package:sdt/l10n/app_localizations.dart";

class ExImportSetting extends StatelessWidget {
  const ExImportSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      children: [
        SizedBox(
          width: screenWidth(context, 0.90),
          child: Row(
            children: [
              Icon(Symbols.warning, color: errorColor(context)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  loc.export_import_hint,
                  style: bodySmall(context).withColor(errorColor(context)),
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Symbols.save_alt),
          title: Text(loc.export_db),
          subtitle: Text(loc.save_backup_to),
          onTap: () async {
            try {
              final ok = await NativeBackup.exportWithPicker();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(ok ? loc.export_success : loc.export_canceled),
                ),
              );
            } catch (e) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(loc.export_failed)));
            }
          },
        ),
        ListTile(
          leading: const Icon(Symbols.restore),
          title: Text(loc.import_db),
          subtitle: Text(loc.pick_a_backup_file),
          onTap: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text(loc.restore_db),
                content: Text(loc.restore_warning),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: Text(loc.cancel.capitalize()),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: Text(loc.restore.capitalize()),
                  ),
                ],
              ),
            );
            if (confirm != true) return;
            try {
              final ok = await NativeBackup.importWithPicker();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    ok ? loc.restore_done_restart : loc.import_canceled,
                  ),
                ),
              );
            } catch (e) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(loc.import_failed)));
            }
          },
        ),
      ],
    );
  }
}
