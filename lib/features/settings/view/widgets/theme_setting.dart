// Package Imports
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:material_symbols_icons/symbols.dart";

// Project Imports
import "package:sdt/features/settings/view/providers/settings_provider.dart";
import "package:sdt/core/utils/constants.dart";
import "package:sdt/core/utils/extensions.dart";
import "package:sdt/l10n/app_localizations.dart";

class ThemeSetting extends ConsumerWidget {
  const ThemeSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final loc = AppLocalizations.of(context)!;

    final themeNames = <String, String>{
      settingsValueThemeModeSystem: loc.system.capitalize(),
      settingsValueThemeModeLight: loc.light.capitalize(),
      settingsValueThemeModeDark: loc.dark.capitalize(),
    };

    final themeModeMap = {
      ThemeMode.system: settingsValueThemeModeSystem,
      ThemeMode.light: settingsValueThemeModeLight,
      ThemeMode.dark: settingsValueThemeModeDark,
    };

    final currentThemeKey = themeModeMap[settings.themeMode];

    return ListTile(
      leading: const Icon(Symbols.brightness_6),
      title: Text(loc.theme.capitalize()),
      subtitle: Text(themeNames[currentThemeKey] ?? currentThemeKey!),
      trailing: const Icon(Symbols.chevron_right),
      onTap: () async {
        final selected = await showModalBottomSheet<ThemeMode>(
          context: context,
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final theme in ThemeMode.values)
                ListTile(
                  leading: Icon(
                    theme == settings.themeMode
                        ? Symbols.radio_button_checked
                        : Symbols.radio_button_unchecked,
                  ),
                  title: Text(themeNames[themeModeMap[theme]] ?? ''),
                  onTap: () => Navigator.pop(context, theme),
                ),
            ],
          ),
        );
        if (selected != null && selected != settings.themeMode) {
          await ref
              .read(settingsNotifierProvider.notifier)
              .updateThemeMode(selected);
        }
      },
    );
  }
}
