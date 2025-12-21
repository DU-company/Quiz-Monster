import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quiz/ad/data/ad_data.dart';
import 'package:flutter_riverpod/legacy.dart';

final interstitialAdProvider =
    StateNotifierProvider.autoDispose<InterstitialAdStateNotifier, InterstitialAd?>(
  (ref) => InterstitialAdStateNotifier(),
);

class InterstitialAdStateNotifier extends StateNotifier<InterstitialAd?> {
  InterstitialAdStateNotifier() : super(null) {
    getAd();
  }

  void getAd() {
    InterstitialAd.load(
      adUnitId: AdMobService.interstitialAdId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('INTERSTITIAL : $ad loaded.');
          // Keep a reference to the ad so you can show it later.
          state = ad;
        },
        onAdFailedToLoad: (error) {
          state = null;
          debugPrint('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  // 광고를 표시하는 메소드
  void showInterstitialAd() {
    if (state != null) {
      state?.show();
    }
  }

// 광고를 해제하는 메소드
  Future<void> disposeAd() async {
    state?.dispose();
    state = null;
  }
}
