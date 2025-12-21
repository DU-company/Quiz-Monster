import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quiz/common/component/primary_button.dart';
import 'package:quiz/common/screen/default_layout.dart';
import 'package:quiz/common/theme/layout.dart';
import 'package:quiz/home/screen/home_screen.dart';
import 'package:quiz/quiz/screen/default_quiz_screen.dart';
import 'package:quiz/time/screen/time_count_screen.dart';

import '../../ad/provider/ad_count_provider.dart';
import '../../ad/provider/interstitial_ad_provider.dart';
import '../../common/component/custom_bottom_sheet.dart';
import '../../common/utils/data_utils.dart';

final _labelProvider = StateProvider((ref) => '');
final _countProvider = StateProvider<int>((ref) => 1);
final _averageProvider = StateProvider<List<int>>((ref) => []);

class ReactionRateScreen extends ConsumerStatefulWidget {
  static String routeName = 'reaction';
  const ReactionRateScreen({super.key});

  @override
  ConsumerState<ReactionRateScreen> createState() => _ReactionRateScreenState();
}

class _ReactionRateScreenState extends ConsumerState<ReactionRateScreen> {
  int? startTime;

  int setRandomTime() {
    return Random().nextInt(2000) + 2000;
  }

  Future<void> countTime() async {
    await Future.delayed(Duration(milliseconds: setRandomTime()));
    ref.read(showAnswerProvider.notifier).state = true;
    startTime = DateTime.now().millisecondsSinceEpoch;
  }

  onTap() {
    if (startTime != null) {
      int reactionTime = DateTime.now().millisecondsSinceEpoch - startTime!;

      int adjustedReactionTime =
          reactionTime >= 51 ? reactionTime - 50 : reactionTime;
      ref.read(_labelProvider.notifier).state = '$adjustedReactionTime ms';
      ref
          .read(_averageProvider.notifier)
          .update((items) => [...items, adjustedReactionTime]);
    } else {
      ref.read(_labelProvider.notifier).state = '너무 빨리 눌렀습니다!';
      ref.read(_countProvider.notifier).update((count) => 0);
      ref.read(_averageProvider.notifier).update((items) => []);
    }
    startTime = null;
  }

  @override
  void initState() {
    super.initState();
    countTime();
  }

  @override
  Widget build(BuildContext context) {
    final showAnswer = ref.watch(showAnswerProvider);
    final label = ref.watch(_labelProvider);
    final count = ref.watch(_countProvider);
    final adCount = ref.watch(adCountProvider);
    final interstitialAd = ref.watch(interstitialAdProvider);
    final testResults = ref.watch(_averageProvider);
    final isEnd = count == 5 && label.isNotEmpty;

    return DefaultLayout(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
            bottom: 16.0,
          ),
          child: context.layout(
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _AppBar(
                    count: count,
                    onBack: onBack,
                  ),
                  if (!isEnd) _Header(isEnd: isEnd),
                  Spacer(),
                  if (isEnd) _AverageBox(testResults: testResults),
                  if (!isEnd)
                    _Body(
                      onTap: label.isEmpty ? onTap : null,
                      showAnswer: showAnswer,
                      label: label,
                    ),
                  Spacer(),
                  _Footer(
                    isEnd: isEnd,
                    onNext: showAnswer && label.isNotEmpty ? onNext : null,
                    onReplay: showAnswer && label.isNotEmpty
                        ? () => onReplay(interstitialAd, adCount)
                        : null,
                  ),
                ],
              ),
              desktop: Column(
                children: [
                  _AppBar(
                    count: count,
                    onBack: onBack,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        if (!isEnd) Expanded(child: _Header(isEnd: isEnd)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (isEnd)
                                Expanded(
                                    child: Center(
                                        child: _AverageBox(
                                            testResults: testResults))),
                              if (!isEnd)
                                Expanded(
                                  child: _Body(
                                    onTap: label.isEmpty ? onTap : null,
                                    showAnswer: showAnswer,
                                    label: label,
                                  ),
                                ),
                              _Footer(
                                isEnd: isEnd,
                                onNext: showAnswer && label.isNotEmpty
                                    ? onNext
                                    : null,
                                onReplay: showAnswer && label.isNotEmpty
                                    ? () => onReplay(interstitialAd, adCount)
                                    : null,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }

  void onBack() {
    showModalBottomSheet(
      backgroundColor: Color(0xFFEFEFEF),
      context: context,
      builder: (context) {
        return CustomBottomSheet(
          title: '게임을 끝내시겠습니까?',
          desc: '',
          label: '게임 계속하기',
          redLabel: '끝내기',
          height: 160,
          onPressed: () => context.pop(), // hide bottom sheet
          onRedPressed: () {
            context.pop();
            resetScreen();
            context.goNamed(HomeScreen.routeName);
          },
        );
      },
    );
  }

  void onNext() {
    ref.read(showAnswerProvider.notifier).state = false;
    ref.read(_labelProvider.notifier).state = '';
    ref.read(_countProvider.notifier).update((count) => count + 1);
    startTime = null;
    countTime();
  }

  void onReplay(InterstitialAd? interstitialAd, int adCount) {
    showModalBottomSheet(
      backgroundColor: Color(0xFFEFEFEF),
      context: context,
      builder: (context) {
        return CustomBottomSheet(
          title: '게임을 다시 진행할까요?',
          desc: '',
          label: '아니오',
          redLabel: '다시 하기',
          height: 160,
          onPressed: () => context.pop(), // hide bottom sheet
          onRedPressed: () {
            context.pop();
            if (interstitialAd == null || adCount < 3) {
              resetScreen();
              startTime = null;
              countTime();
              ref.read(adCountProvider.notifier).addCount();
            } else {
              ref.read(adCountProvider.notifier).resetCount();

              /// 광고를 띄운다
              DataUtils.showInterstitialAd(
                interstitialAd: interstitialAd,
                moveToScreen: () {
                  resetScreen();
                  startTime = null;
                  countTime();
                },
              );
              ref.read(interstitialAdProvider.notifier).getAd();
            }
          },
        );
      },
    );
  }

  void resetScreen() {
    ref.read(showAnswerProvider.notifier).state = false;
    ref.read(_labelProvider.notifier).state = '';
    ref.read(_countProvider.notifier).update((count) => 1);
    ref.read(_averageProvider.notifier).state = [];
  }
}

class _AppBar extends StatelessWidget {
  final int count;
  final VoidCallback onBack;
  const _AppBar({
    super.key,
    required this.count,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          style: IconButton.styleFrom(
            foregroundColor: Colors.white,
          ),
          onPressed: onBack,
          icon: Icon(
            Icons.arrow_back_ios,
          ),
        ),
        Text(
          '$count/5 회',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final bool isEnd;
  const _Header({
    required this.isEnd,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        '원이 초록색이 되면\n원을 클릭해 주세요',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: context.layout(32, mobile: 24),
          color: Colors.white,
        ),
      ),
    );
  }
}

class _AverageBox extends StatelessWidget {
  final List<int> testResults;
  const _AverageBox({
    super.key,
    required this.testResults,
  });

  @override
  Widget build(BuildContext context) {
    final int average = testResults.isNotEmpty
        ? (testResults.reduce((a, b) => a + b) / testResults.length).toInt()
        : 0;
    final comment = DataUtils.getReactionSpeedMessage(average);

    return Column(
      children: [
        Text(
          comment,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: context.layout(28, mobile: 20),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          '평균속도 : ${average.toInt()} ms'
          '\n${testResults.map(
                (e) => '${e}ms',
              ).toList()}',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: context.layout(32, mobile: 24),
          ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final VoidCallback? onTap;
  final bool showAnswer;
  final String? label;
  const _Body({
    super.key,
    required this.onTap,
    required this.showAnswer,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: showAnswer ? Colors.lightGreen : Colors.white,
            ),
            height: context.layout(350, mobile: 250),
            child: Center(
              child: Text(
                showAnswer ? 'CLICK HERE!' : 'Waitng...',
                style: TextStyle(
                  fontSize: context.layout(32, mobile: 20),
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            label == null ? '' : label!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: context.layout(28, mobile: 20),
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  final bool isEnd;
  final VoidCallback? onReplay;
  final VoidCallback? onNext;

  const _Footer({
    super.key,
    required this.isEnd,
    required this.onReplay,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      label: isEnd ? '다시 시작' : '다음',
      onPressed: isEnd ? onReplay : onNext,
    );
  }
}
