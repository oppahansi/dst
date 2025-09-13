// Package Imports
import "package:flutter/foundation.dart"
    show kReleaseMode, defaultTargetPlatform, TargetPlatform;

/// Google official test Banner IDs
const _androidBannerTest = "ca-app-pub-3940256099942544/9214589741";
const _iosBannerTest = "ca-app-pub-3940256099942544/2934735716";

/// Production unit IDs (FILL IN with your real ones; keep only on ads branch)
const _androidBannerProd = "ca-app-pub-2910994499798273/7454077784";
const _iosBannerProd = "ca-app-pub-2910994499798273/3271290198";

class AdIds {
  static bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;
  static bool get _isIOS => defaultTargetPlatform == TargetPlatform.iOS;

  static bool get usingTestIds => !kReleaseMode;

  static String get banner {
    if (_isAndroid) {
      return kReleaseMode
          ? (_androidBannerProd.isNotEmpty
                ? _androidBannerProd
                : _androidBannerTest)
          : _androidBannerTest;
    }
    if (_isIOS) {
      return kReleaseMode
          ? (_iosBannerProd.isNotEmpty ? _iosBannerProd : _iosBannerTest)
          : _iosBannerTest;
    }
    return ""; // unsupported platform -> no ad
  }
}
