// Dart Imports
import 'dart:async';

// Flutter Imports
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package Imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Project Imports
import 'package:sdt/ads/ads_init.dart';
import 'package:sdt/core/cfg/themes.dart';
import 'package:sdt/core/utils/constants.dart';
import 'package:sdt/features/sdt/view/screens/sdt_add_screen.dart';
import 'package:sdt/features/home/home_screen.dart';
import 'package:sdt/features/settings/view/screens/settings_screen.dart';
import 'package:sdt/features/settings/view/providers/settings_provider.dart';
import 'package:sdt/l10n/app_localizations.dart';
import 'package:sdt/app/main_screen.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      FlutterError.onError = (details) {
        FlutterError.presentError(details);
        if (kDebugMode) {
          debugPrint("FlutterError: ${details.exceptionAsString()}");
          debugPrint(details.stack?.toString());
        }
      };

      unawaited(
        AdsInitializer.ensureInitialized().then((_) async {
          // Mark physical device as test to suppress reminder log.
          await MobileAds.instance.updateRequestConfiguration(
            RequestConfiguration(
              testDeviceIds: const ['95B835426DA8908869340236E7D7D8EB'],
            ),
          );
        }),
      );

      final initialSettings = await loadInitialSettings();

      runApp(
        ProviderScope(
          overrides: [
            settingsNotifierProvider.overrideWith(
              () => SettingsNotifier(initialSettings),
            ),
          ],
          child: const MyApp(),
        ),
      );
    },
    (error, stack) {
      if (kDebugMode) {
        debugPrint("Zoned error: $error\n$stack");
      }
    },
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);

    return MaterialApp(
      title: appTitle,
      themeMode: settings.themeMode,
      theme: light,
      darkTheme: dark,
      locale: settings.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routes: {
        HomeScreen.path: (context) => const MainScreen(child: HomeScreen()),
        SettingsScreen.path: (context) =>
            const MainScreen(child: SettingsScreen()),
        SdtAddScreen.path: (context) => SdtAddScreen(),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => const MainScreen(child: HomeScreen()),
      ),
    );
  }
}
