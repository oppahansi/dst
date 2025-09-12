// Package Imports
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

// Project Imports
import "package:sdtpro/core/widgets/debug_settings_controlls.dart";

class DtScreen extends StatelessWidget {
  const DtScreen({super.key});

  static const String path = "/daysto";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [if (kDebugMode) DebugSettingsControlls()]),
      ),
    );
  }
}
