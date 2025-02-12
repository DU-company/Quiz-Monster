import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quiz/ad/data/ad_data.dart';

final adStateNotifierProvider = StateNotifierProvider<AdStateNotifier, dynamic>(
  (ref) {
    return AdStateNotifier();
  },
);

class AdStateNotifier extends StateNotifier<dynamic> {
  AdStateNotifier() : super(null) {
    // loadBannerAd();
    // loadInterstitialAd();
    loadRewardedAd();
  }


  void loadBannerAd() async {
    state = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded');
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  void loadInterstitialAd() {
    // state = null;
    try {
      InterstitialAd.load(
        adUnitId: AdMobService.interstitialAdId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) => state = ad,
          onAdFailedToLoad: (error) => state = null,
        ),
      );
      // final pState = state as InterstitialAd;
      //
      // pState.fullScreenContentCallback = FullScreenContentCallback(
      //   onAdDismissedFullScreenContent: (ad) {
      //     ad.dispose();
      //   },
      //   onAdFailedToShowFullScreenContent: (ad, error) {
      //     ad.dispose();
      //   },
      // );
      // pState.show();
      // state = null;
    } catch (e) {
      print(e);
    }
  }

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdMobService.rewardedAdId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          state = ad;
        },
        onAdFailedToLoad: (error) {
          state = null;
        },
      ),
    );
  }

  void setToNull() {
    state = null;
  }
}
