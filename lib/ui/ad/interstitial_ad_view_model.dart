import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quiz_monster/core/service/ad_service.dart';
import 'package:quiz_monster/ui/ad/ad_count_provider.dart';
import 'package:quiz_monster/ui/ad/ad_finished_provider.dart';

final interstitialAdViewModelProvider = AsyncNotifierProvider(
  () => InterstitialAdViewModel(),
);

class InterstitialAdViewModel extends AsyncNotifier<InterstitialAd?> {
  @override
  Future<InterstitialAd?> build() async {
    ref.onDispose(() {
      _ad?.dispose();
      _ad = null;
    });
    return _loadAd();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadAd());
  }

  InterstitialAd? _ad;

  Future<InterstitialAd?> _loadAd() {
    final completer = Completer<InterstitialAd?>();

    InterstitialAd.load(
      adUnitId: AdMobService.interstitialAdId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              ref.read(adFinishedProvider.notifier).onFinish();
              reload(); // 다음 광고 미리 로드
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              ref.read(adFinishedProvider.notifier).onFinish();
              reload();
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

  void showAd() {
    final shouldShow = state.hasValue && state.value != null;
    final adCount = ref.read(adCountProvider);

    if (shouldShow && adCount >= 3) {
      ref.read(adCountProvider.notifier).resetCount();
      state.value!.show();
      print('광고 보여줌 ');
    } else {
      ref.read(adFinishedProvider.notifier).onFinish();
      ref.read(adCountProvider.notifier).increaseCount();
      print('광고 안보여줌');
    }
  }
}
