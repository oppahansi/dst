// Dart Imports
import "dart:async";

// Flutter Imports
import "package:flutter/foundation.dart";

// Package Imports
import "package:google_mobile_ads/google_mobile_ads.dart";

class AdsInitializer {
  static bool _initialized = false;
  static bool _failed = false;

  static Future<void> ensureInitialized({
    // Give more time; initialization occasionally needs >5s on cold start/emulator.
    Duration softTimeout = const Duration(seconds: 12),
  }) async {
    if (_initialized || _failed) return;
    bool timedOut = false;
    try {
      final initFuture = MobileAds.instance.initialize().then((_) {
        if (!timedOut) _initialized = true;
      });
      await initFuture.timeout(
        softTimeout,
        onTimeout: () {
          timedOut = true;
          _failed = true;
          if (kDebugMode) {
            debugPrint("Ads init soft-timeout; continuing without ads.");
          }
        },
      );
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint("Ads init error (continuing without ads): $e\n$st");
      }
      _failed = true;
    }
  }

  static bool get isReady => _initialized;
  static bool get isFailed => _failed;
}
