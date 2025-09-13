// Package Imports
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:material_symbols_icons/symbols.dart";

// Project Imports
import "package:sdt/features/settings/view/providers/settings_provider.dart";
import "package:sdt/core/utils/colors.dart";

class DebugSettingsControlls extends ConsumerWidget {
  const DebugSettingsControlls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);

    return Card(
      margin: const EdgeInsets.all(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Theme
            Switch(
              thumbIcon: WidgetStateProperty.all(
                (settings.themeMode == ThemeMode.dark)
                    ? Icon(Symbols.dark_mode, color: primaryColor(context))
                    : Icon(Symbols.light_mode, color: secondaryColor(context)),
              ),
              value: settings.themeMode == ThemeMode.dark,
              onChanged: (isDark) {
                final newMode = isDark ? ThemeMode.dark : ThemeMode.light;
                ref
                    .read(settingsNotifierProvider.notifier)
                    .updateThemeMode(newMode);
              },
            ),
            const SizedBox(width: 4),
            // Language
            DropdownButton<String>(
              value: settings.locale.languageCode,
              underline: const SizedBox(),
              icon: const Icon(Symbols.language, size: 18),
              style: Theme.of(context).textTheme.bodyMedium,
              onChanged: (String? code) {
                if (code != null) {
                  ref
                      .read(settingsNotifierProvider.notifier)
                      .updateLocale(Locale(code));
                }
              },
              items: const [
                DropdownMenuItem(value: "en", child: Text("EN")),
                DropdownMenuItem(value: "de", child: Text("DE")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
