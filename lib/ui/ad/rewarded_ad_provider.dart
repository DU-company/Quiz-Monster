import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quiz_monster/core/service/ad_service.dart';

final rewardedAdProvider =
    StateNotifierProvider.autoDispose<
      RewardedAdStateNotifier,
      RewardedAd?
    >((ref) => RewardedAdStateNotifier());

class RewardedAdStateNotifier extends StateNotifier<RewardedAd?> {
  RewardedAdStateNotifier() : super(null) {
    getAd();
  }

  void getAd() {
    RewardedAd.load(
      adUnitId: AdMobService.rewardedAdId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('REWARDED : $ad loaded.');
          state = ad;
        },
        onAdFailedToLoad: (error) {
          debugPrint('RewardedAd failed to load: $error');
          state = null;
        },
      ),
    );
  }

  void showAd({required VoidCallback onRewardEarned}) {
    if (state == null) {
      debugPrint('광고가 아직 로드되지 않았습니다.');
      return;
    }

    state!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        debugPrint('광고가 닫혔습니다.');
        ad.dispose();
        state = null;
        // getAd(); // 광고 다시 로드
      },
      onAdFailedToShowFullScreenContent:
          (RewardedAd ad, AdError error) {
            debugPrint('광고 표시 실패: $error');
            ad.dispose();
            state = null;
          },
    );

    state!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        debugPrint('보상 획득!');
        onRewardEarned(); // 보상 지급 로직 실행
        ad.dispose();
        state = null;
      },
    );
  }

  // 광고를 해제하는 메소드
  void disposeAd() {
    state?.dispose();
    state = null;
  }
}
