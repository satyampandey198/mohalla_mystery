// lib/services/ad_service.dart

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  BannerAd? _bannerAd;

  bool _isInterstitialLoaded = false;
  bool _isRewardedLoaded = false;

  // 🔴 PRODUCTION: Replace these with your real AdMob IDs from Google AdMob Console
  // 🟢 TEST IDs (use these during development):
  static const String _bannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111'; // Test Banner
  static const String _interstitialAdUnitId =
      'ca-app-pub-3940256099942544/1033173712'; // Test Interstitial
  static const String _rewardedAdUnitId =
      'ca-app-pub-3940256099942544/5224354917'; // Test Rewarded

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    loadInterstitialAd();
    loadRewardedAd();
  }

  // ─── BANNER AD ───────────────────────────────────
  BannerAd? get bannerAd => _bannerAd;

  void loadBannerAd(Function onLoaded) {
    _bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _bannerAd = ad as BannerAd;
          onLoaded();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _bannerAd = null;
        },
      ),
    )..load();
  }

  void disposeBannerAd() {
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  // ─── INTERSTITIAL AD ─────────────────────────────
  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoaded = true;
        },
        onAdFailedToLoad: (error) {
          _isInterstitialLoaded = false;
        },
      ),
    );
  }

  void showInterstitialAd({VoidCallback? onComplete}) {
    if (_isInterstitialLoaded && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _isInterstitialLoaded = false;
          loadInterstitialAd(); // Preload next
          onComplete?.call();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          onComplete?.call();
        },
      );
      _interstitialAd!.show();
    } else {
      onComplete?.call();
    }
  }

  // ─── REWARDED AD ─────────────────────────────────
  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedLoaded = true;
        },
        onAdFailedToLoad: (error) {
          _isRewardedLoaded = false;
        },
      ),
    );
  }

  void showRewardedAd({
    required Function(RewardItem reward) onRewarded,
    VoidCallback? onFailed,
  }) {
    if (_isRewardedLoaded && _rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _isRewardedLoaded = false;
          loadRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          onFailed?.call();
        },
      );
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) => onRewarded(reward),
      );
    } else {
      onFailed?.call();
    }
  }

  bool get isRewardedAdReady => _isRewardedLoaded;
  bool get isInterstitialAdReady => _isInterstitialLoaded;

  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _bannerAd?.dispose();
  }
}

// ─── Banner Ad Widget ─────────────────────────────
class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    AdService().loadBannerAd(() {
      if (mounted) {
        setState(() {
          _bannerAd = AdService().bannerAd;
          _isLoaded = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox(height: 50);
    }
    return SizedBox(
      height: _bannerAd!.size.height.toDouble(),
      width: _bannerAd!.size.width.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
