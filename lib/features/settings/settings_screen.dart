// Flutter Imports
import "package:flutter/material.dart";

// Package Imports
import "package:sdtpro/core/utils/colors.dart";
import "package:sdtpro/core/utils/extensions.dart";
import "package:sdtpro/core/utils/text_styles.dart";
import "package:sdtpro/features/settings/language_setting.dart";
import "package:sdtpro/features/settings/theme_setting.dart";
import "package:sdtpro/l10n/app_localizations.dart";

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
          ],
        ),
      ),
    );
  }
}
