import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quiz/core/provider/selected_quiz_provider.dart';
import 'package:quiz/core/utils/data_utils.dart';
import 'package:quiz/ui/ad/ad_count_provider.dart';
import 'package:quiz/ui/ad/interstitial_ad_view_model.dart';
import 'package:quiz/ui/settings/time/time_count_screen.dart';

final timeViewModelProvider = NotifierProvider.autoDispose(
  () => TimeViewModel(),
);

class TimeViewModel extends Notifier<Duration> {
  @override
  Duration build() {
    return init();
  }

  Duration init() {
    final hasPass = ref.read(selectedQuizProvider)!.hasPass;
    state = hasPass ? Duration(minutes: 3) : Duration(seconds: 5);
    return state;
  }

  void onTimeChanged(Duration duration) {
    state = duration;
  }

  void onTapStart(BuildContext context) {
    // final interstitialAd = ref.read(interstitialAdProvider);
    // final adCount = ref.read(adCountProvider);

    if (state.inSeconds < 3) {
      DataUtils.showToast(msg: '최소 제한 시간은 3초 입니다.');
    } else {
      ref.read(interstitialAdViewModelProvider.notifier).showAd();
      // if (interstitialAd == null || adCount < 3) {
      //   /// 광고 없이 실행
      //   context.goNamed(TimeCountScreen.routeName);
      //
      //   ref.read(adCountProvider.notifier).increaseCount();
      // } else {
      //   ref.read(adCountProvider.notifier).resetCount();
      //
      //   /// 광고 실행
      //   interstitialAd.fullScreenContentCallback =
      //       FullScreenContentCallback(
      //         onAdDismissedFullScreenContent: (ad) {
      //           context.goNamed(TimeCountScreen.routeName);
      //         },
      //         onAdFailedToShowFullScreenContent: (ad, error) {
      //           context.goNamed(TimeCountScreen.routeName);
      //         },
      //       );
      //   interstitialAd.show();
      // }
    }
  }
}
