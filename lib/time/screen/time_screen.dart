import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quiz/ad/provider/ad_count_provider.dart';
import 'package:quiz/ad/provider/interstitial_ad_provider.dart';
import 'package:quiz/common/component/primary_button.dart';
import 'package:quiz/common/provider/selected_quiz_provider.dart';
import 'package:quiz/common/theme/layout.dart';
import 'package:quiz/common/utils/data_utils.dart';
import 'package:quiz/setting/screen/responsive_screen.dart';
import 'package:quiz/time/provider/time_provider.dart';
import 'package:quiz/time/screen/time_count_screen.dart';

class TimeScreen extends ConsumerWidget {
  static String routeName = 'time';

  const TimeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interstitialAd = ref.watch(interstitialAdProvider);
    final adCount = ref.watch(adCountProvider);
    final selectedQuiz = ref.watch(selectedQuizProvider);
    Duration newDuration =
        selectedQuiz!.pass ? Duration(minutes: 3) : Duration(seconds: 5);

    return ResponsiveSettingScreen(
      label: selectedQuiz.pass ? '총 게임 시간을\n설정해 주세요' : '1인 제한 시간을\n설정해 주세요',
      body: _Body(
        newDuration: newDuration,
        onTimerDurationChanged: (duration) {
          newDuration = duration;
        },
      ),
      footer: _Footer(
        onPressed: () async {
          if (newDuration.inSeconds < 3) {
            DataUtils.showToast(msg: '최소 제한 시간은 3초 입니다.');
          } else {
            if (interstitialAd == null || adCount < 3) {
              /// 광고없이 실행시킨다.
              onGameStart(context, ref, newDuration);
              ref.read(adCountProvider.notifier).addCount();
            } else {
              ref.read(adCountProvider.notifier).resetCount();

              /// 광고를 띄운다
              interstitialAd.fullScreenContentCallback =
                  FullScreenContentCallback(
                onAdDismissedFullScreenContent: (ad) {
                  onGameStart(context, ref, newDuration);
                },
                onAdFailedToShowFullScreenContent: (ad, error) {
                  onGameStart(context, ref, newDuration);
                },
              );
              interstitialAd.show();
            }
          }
        },
      ),
    );
  }

  void onGameStart(BuildContext context, WidgetRef ref, Duration newDuration) {
    ref.read(timeProvider.notifier).state = newDuration;
    context.goNamed(
      TimeCountScreen.routeName,
    );
  }
}

class _Body extends StatelessWidget {
  final void Function(Duration) onTimerDurationChanged;
  final Duration newDuration;
  const _Body({
    super.key,
    required this.newDuration,
    required this.onTimerDurationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.layout(300, mobile: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
      ),
      child: CupertinoTimerPicker(
        mode: CupertinoTimerPickerMode.ms,
        initialTimerDuration: newDuration,
        onTimerDurationChanged: onTimerDurationChanged,
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final VoidCallback onPressed;
  const _Footer({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      label: 'START',
      onPressed: onPressed,
    );
  }
}
