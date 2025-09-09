// Flutter Imports
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

// Package Imports
import "package:material_symbols_icons/symbols.dart";
import "package:sdtpro/core/provider/settings_service_provider.dart";
import "package:sdtpro/core/utils/extensions.dart";
import "package:sdtpro/l10n/app_localizations.dart";

class LanguageSetting extends ConsumerWidget {
  const LanguageSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsServiceNotifierProvider);
    final loc = AppLocalizations.of(context)!;

    final languageNames = <String, String>{
      "en": loc.english.capitalize(),
      "de": loc.german.capitalize(),
    };

    return settingsAsync.when(
      data: (settings) {
        final currentLocale = settings.locale;
        final supportedLocales = AppLocalizations.supportedLocales;

        return ListTile(
          leading: const Icon(Symbols.language),
          title: Text(loc.language.capitalize()),
          subtitle: Text(
            languageNames[currentLocale.languageCode] ??
                currentLocale.languageCode,
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
                        languageNames[locale.languageCode] ??
                            locale.languageCode,
                      ),
                      onTap: () => Navigator.pop(context, locale),
                    ),
                ],
              ),
            );
            if (selected != null && selected != currentLocale) {
              await ref
                  .read(settingsServiceNotifierProvider.notifier)
                  .setSetting("locale", selected.languageCode);
            }
          },
        );
      },
      loading: () => ListTile(
        leading: const Icon(Symbols.language),
        title: Text(loc.language),
        subtitle: Text("${loc.loading}..."),
      ),
      error: (e, st) => ListTile(
        leading: const Icon(Symbols.language),
        title: Text(loc.language),
        subtitle: Text("Error: $e"),
      ),
    );
  }
}
