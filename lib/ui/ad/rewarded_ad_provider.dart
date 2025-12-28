import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quiz_monster/core/service/ad_service.dart';

final rewardedAdViewModelProvider = AsyncNotifierProvider.autoDispose(
  () => RewardedAdViewModel(),
);

class RewardedAdViewModel extends AsyncNotifier<RewardedAd?> {
  @override
  FutureOr<RewardedAd?> build() {
    return _loadAd();
  }

  Future<void> _reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadAd());
  }

  Future<RewardedAd?> _loadAd() async {
    final completer = Completer<RewardedAd?>();

    RewardedAd.load(
      adUnitId: AdMobService.rewardedAdId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
            },
          );
          completer.complete(ad);
        },
        onAdFailedToLoad: (error) {
          completer.completeError(error);
        },
      ),
    );

    return completer.future;
  }

  void showAd({required VoidCallback onRewarded}) {
    final shouldShow = state is AsyncData && state.value != null;

    if (shouldShow) {
      state.value!.show(
        onUserEarnedReward: (ad, reward) {
          onRewarded();
          state = AsyncLoading();
        },
      );
    }
  }
}
