// Flutter Imports
import 'package:flutter/material.dart';

// Package Imports
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project Imports
import 'package:oppa_app/core/cfg/themes.dart';
import 'package:oppa_app/core/provider/settings_service_provider.dart';
import 'package:oppa_app/features/home/home_screen.dart';
import 'package:oppa_app/l10n/app_localizations.dart';
import 'package:oppa_app/main_screen.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var settingsAsync = ref.watch(settingsServiceNotifierProvider);

    return settingsAsync.when(
      data: (settings) => MaterialApp(
        title: "App Title",
        themeMode: settings.themeMode,
        theme: light,
        darkTheme: dark,
        locale: settings.locale,
        supportedLocales: const [Locale("en", ""), Locale("de", "")],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routes: {},
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => const MainScreen(child: HomeScreen()),
        ),
      ),
      loading: () => Center(child: const CircularProgressIndicator()),
      error: (e, st) => Center(child: Text("Error: $e")),
    );
  }
}
