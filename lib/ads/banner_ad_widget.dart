import "dart:async";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:google_mobile_ads/google_mobile_ads.dart";
import "ads_ids.dart";
import "ads_init.dart";

class BannerAdContainer extends StatefulWidget {
  const BannerAdContainer({super.key});
  @override
  State<BannerAdContainer> createState() => _BannerAdContainerState();
}

class _BannerAdContainerState extends State<BannerAdContainer> {
  BannerAd? _ad;
  bool _loaded = false;
  bool _disposed = false;
  bool _attempted = false;
  bool _retriedInternalError = false; // retry once for internal error code=0

  @override
  void initState() {
    super.initState();
    // Do NOT call _load() here because MediaQuery dependencies
    // are not yet allowed. We defer to didChangeDependencies.
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_attempted) {
      _load();
    }
  }

  Future<void> _load() async {
    if (_attempted) return;
    _attempted = true;

    // Lazy init
    if (!AdsInitializer.isReady && !AdsInitializer.isFailed) {
      unawaited(AdsInitializer.ensureInitialized());
    }
    if (AdsInitializer.isFailed) return;

    // Try adaptive size (fallback to standard banner)
    AdSize size = AdSize.banner;
    try {
      final mq = MediaQuery.maybeOf(context);
      if (mq != null) {
        // Must use logical width (dp) – DO NOT multiply by devicePixelRatio.
        var logicalWidth = mq.size.width.truncate();

        // (Optional) Clamp to reasonable AdMob range.
        logicalWidth = logicalWidth.clamp(320, 1200);

        if (kDebugMode) {
          debugPrint("Attempting adaptive banner width=$logicalWidth");
        }

        final adaptive =
            await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
              logicalWidth,
            );
        if (adaptive != null) {
          size = adaptive;
          if (kDebugMode)
            debugPrint("Adaptive banner size acquired: $adaptive");
        } else {
          if (kDebugMode)
            debugPrint("Adaptive banner size null, using standard.");
        }
      }
    } catch (e) {
      if (kDebugMode) debugPrint("Adaptive banner sizing failed: $e");
      // ignore, keep default size
    }

    try {
      final ad = BannerAd(
        size: size,
        adUnitId: AdIds.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (_) {
            if (_disposed) return;
            setState(() => _loaded = true);
          },
          onAdFailedToLoad: (ad, error) {
            if (kDebugMode) {
              debugPrint(
                "Banner load failed code=${error.code} domain=${error.domain} "
                "message=${error.message} responseInfo=${error.responseInfo}",
              );
            }
            ad.dispose();
            if (_disposed) return;

            // Single delayed retry for transient internal error (code 0).
            if (error.code == 0 && !_retriedInternalError) {
              _retriedInternalError = true;
              if (kDebugMode) {
                debugPrint("Scheduling one retry for internal error 0...");
              }
              // Reset attempt flags for retry.
              _attempted = false;
              Future.delayed(const Duration(seconds: 3), () {
                if (!_disposed && mounted) {
                  _load();
                }
              });
              return;
            }

            if (mounted) {
              setState(() {
                _loaded = false;
                _ad = null;
              });
            }
          },
        ),
      );
      _ad = ad;
      ad.load();
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Banner construction error: $e");
      }
      _ad?.dispose();
      _ad = null;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _ad == null) return const SizedBox.shrink();
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: SizedBox(
        width: _ad!.size.width.toDouble(),
        height: _ad!.size.height.toDouble(),
        child: AdWidget(ad: _ad!),
      ),
    );
  }
}
