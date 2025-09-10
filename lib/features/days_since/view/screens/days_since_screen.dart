// Package Imports
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

// Project Imports
import "package:sdtpro/core/widgets/debug_settings_controlls.dart";
import "package:sdtpro/l10n/app_localizations.dart";

class DaysSinceScreen extends StatelessWidget {
  const DaysSinceScreen({super.key});

  static const String path = "/dayssince";

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [if (kDebugMode) DebugSettingsControlls()]),
      ),
    );
  }
}
