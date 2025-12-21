import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../core/service/ad_service.dart';

final bannerAdProvider =
    StateNotifierProvider.autoDispose<BannerAdStateNotifier, BannerAd?>(
  (ref) => BannerAdStateNotifier(),
);

class BannerAdStateNotifier extends StateNotifier<BannerAd?> {
  BannerAdStateNotifier() : super(null) {
    getAd();
  }

  late BannerAd bannerAd;

  void getAd() {
    bannerAd = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('BANNER : $ad loaded');
          state = bannerAd;
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
          state = null;
        },
        onAdClosed: (ad) {
          ad.dispose();
          state = null;
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    bannerAd.dispose(); // 광고 객체 정리
    super.dispose();
  }
}
