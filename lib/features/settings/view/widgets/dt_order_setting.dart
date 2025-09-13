// Flutter Imports
import 'package:flutter/material.dart';

// Package Imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

// Project Imports
import 'package:sdt/features/settings/view/providers/settings_provider.dart';
import 'package:sdt/features/settings/domain/entities/settings.dart';
import 'package:sdt/l10n/app_localizations.dart';

class DtOrderSetting extends ConsumerWidget {
  const DtOrderSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final loc = AppLocalizations.of(context)!;

    return ListTile(
      leading: const Icon(Symbols.sort),
      title: Text(loc.days_to_sort_order),
      subtitle: Text(
        settings.dtSortOrder == SdtSortOrder.asc
            ? loc.ascending_small_to_big
            : loc.descending_big_to_small,
      ),
      trailing: const Icon(Symbols.chevron_right),
      onTap: () async {
        final selected = await showModalBottomSheet<SdtSortOrder>(
          context: context,
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  settings.dtSortOrder == SdtSortOrder.asc
                      ? Symbols.radio_button_checked
                      : Symbols.radio_button_unchecked,
                ),
                title: Text(loc.ascending_small_to_big),
                onTap: () => Navigator.pop(context, SdtSortOrder.asc),
              ),
              ListTile(
                leading: Icon(
                  settings.dtSortOrder == SdtSortOrder.desc
                      ? Symbols.radio_button_checked
                      : Symbols.radio_button_unchecked,
                ),
                title: Text(loc.descending_big_to_small),
                onTap: () => Navigator.pop(context, SdtSortOrder.desc),
              ),
            ],
          ),
        );
        if (selected != null && selected != settings.dtSortOrder) {
          await ref
              .read(settingsNotifierProvider.notifier)
              .updateDtSortOrder(selected);
        }
      },
    );
  }
}
