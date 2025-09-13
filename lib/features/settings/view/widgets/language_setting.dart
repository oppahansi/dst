// Package Imports
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:material_symbols_icons/symbols.dart";

// Project Imports
import "package:sdt/features/settings/view/providers/settings_provider.dart";
import "package:sdt/core/utils/extensions.dart";
import "package:sdt/l10n/app_localizations.dart";

class LanguageSetting extends ConsumerWidget {
  const LanguageSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final loc = AppLocalizations.of(context)!;

    final languageNames = <String, String>{
      "en": loc.english.capitalize(),
      "de": loc.german.capitalize(),
    };

    final currentLocale = settings.locale;
    final supportedLocales = AppLocalizations.supportedLocales;

    return ListTile(
      leading: const Icon(Symbols.language),
      title: Text(loc.language.capitalize()),
      subtitle: Text(
        languageNames[currentLocale.languageCode] ?? currentLocale.languageCode,
      ),
      trailing: const Icon(Symbols.chevron_right),
      onTap: () async {
        final selected = await showModalBottomSheet<Locale>(
          context: context,
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final locale in supportedLocales)
                ListTile(
                  leading: Icon(
                    locale.languageCode == currentLocale.languageCode
                        ? Symbols.radio_button_checked
                        : Symbols.radio_button_unchecked,
                  ),
                  title: Text(
                    languageNames[locale.languageCode] ?? locale.languageCode,
                  ),
                  onTap: () => Navigator.pop(context, locale),
                ),
            ],
          ),
        );
        if (selected != null && selected != currentLocale) {
          await ref
              .read(settingsNotifierProvider.notifier)
              .updateLocale(selected);
        }
      },
    );
  }
}
