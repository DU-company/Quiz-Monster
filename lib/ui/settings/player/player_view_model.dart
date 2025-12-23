import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz/core/service/selected_quiz_provider.dart';
import 'package:quiz/ui/ad/ad_count_provider.dart';
import 'package:quiz/ui/ad/interstitial_ad_provider.dart';
import 'package:quiz/core/utils/data_utils.dart';
import 'package:quiz/ui/quiz/etc/liar/liar_screen.dart';
import 'package:quiz/ui/settings/time/time_count_screen.dart';

final playerViewModelProvider = NotifierProvider(
  () => PlayerViewModel(),
);

class PlayerViewModel extends Notifier<int> {
  @override
  int build() {
    state = 3;
    return state;
  }

  void increasePlayer() async {
    state = state + 1;
  }

  void decreasePlayer() {
    state = state - 1;
  }

  void onStart(BuildContext context) {
    final interstitialAd = ref.read(interstitialAdProvider);
    final adCount = ref.read(adCountProvider);

    if (interstitialAd == null || adCount < 3) {
      ref.read(adCountProvider.notifier).increaseCount();

      context.goNamed(TimeCountScreen.routeName);
    } else {
      ref.read(adCountProvider.notifier).resetCount();

      /// 광고를 띄운다
      DataUtils.showInterstitialAd(
        interstitialAd: interstitialAd,
        moveToScreen: () =>
            context.goNamed(TimeCountScreen.routeName),
      );
    }
  }
}
