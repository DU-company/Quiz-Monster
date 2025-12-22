import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quiz/ad/provider/ad_count_provider.dart';
import 'package:quiz/ad/provider/interstitial_ad_provider.dart';
import 'package:quiz/ui/common/widgets/primary_button.dart';
import 'package:quiz/core/service/selected_quiz_provider.dart';
import 'package:quiz/core/theme/responsive/layout.dart';
import 'package:quiz/core/utils/data_utils.dart';
import 'package:quiz/ui/common/layout/setting_layout.dart';
import 'package:quiz/ui/settings/time/time_provider.dart';
import 'package:quiz/ui/settings/time/time_count_screen.dart';
import 'package:quiz/ui/settings/time/widgets/time_picker.dart';

class TimeScreen extends ConsumerWidget {
  static String routeName = 'time';

  const TimeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interstitialAd = ref.watch(interstitialAdProvider);
    final adCount = ref.watch(adCountProvider);
    final selectedQuiz = ref.watch(selectedQuizProvider);
    Duration newDuration = selectedQuiz!.hasPass
        ? Duration(minutes: 3)
        : Duration(seconds: 5);

    return SettingLayout(
      label: selectedQuiz.hasPass
          ? '총 게임 시간을\n설정해 주세요'
          : '1인 제한 시간을\n설정해 주세요',
      body: TimePicker(
        newDuration: newDuration,
        onTimerDurationChanged: (duration) {
          newDuration = duration;
        },
      ),
      footer: PrimaryButton(
        label: 'START',
        onPressed: () async {
          /// TODO : 뷰모델로?
          if (newDuration.inSeconds < 3) {
            DataUtils.showToast(msg: '최소 제한 시간은 3초 입니다.');
          } else {
            if (interstitialAd == null || adCount < 3) {
              /// 광고 없이 실행
              onTapStart(context, ref, newDuration);
              ref.read(adCountProvider.notifier).increaseCount();
            } else {
              ref.read(adCountProvider.notifier).resetCount();

              /// 광고 실행
              interstitialAd.fullScreenContentCallback =
                  FullScreenContentCallback(
                    onAdDismissedFullScreenContent: (ad) {
                      onTapStart(context, ref, newDuration);
                    },
                    onAdFailedToShowFullScreenContent: (ad, error) {
                      onTapStart(context, ref, newDuration);
                    },
                  );
              interstitialAd.show();
            }
          }
        },
      ),
    );
  }

  void onTapStart(
    BuildContext context,
    WidgetRef ref,
    Duration newDuration,
  ) {
    ref.read(timeProvider.notifier).state = newDuration;
    context.goNamed(TimeCountScreen.routeName);
  }
}
