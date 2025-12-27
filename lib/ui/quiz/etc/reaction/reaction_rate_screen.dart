import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quiz/core/utils/data_utils.dart';
import 'package:quiz/ui/ad/ad_count_provider.dart';
import 'package:quiz/ui/ad/ad_finished_provider.dart';
import 'package:quiz/ui/ad/interstitial_ad_view_model.dart';
import 'package:quiz/ui/common/layout/quiz_detail_layout.dart';
import 'package:quiz/ui/common/screens/home_screen.dart';
import 'package:quiz/ui/common/widgets/dialog/base_confirm_dialog.dart';
import 'package:quiz/ui/common/widgets/primary_button.dart';
import 'package:quiz/ui/common/layout/default_layout.dart';
import 'package:quiz/core/theme/responsive/layout.dart';
import 'package:quiz/ui/quiz/detail/widgets/quiz_detail_success_view.dart';
import 'package:quiz/ui/quiz/detail/widgets/exit_dialog.dart';
import 'package:quiz/ui/quiz/etc/reaction/widgets/reaction_app_bar.dart';
import 'package:quiz/ui/quiz/etc/reaction/widgets/reaction_average_box.dart';
import 'package:quiz/ui/quiz/etc/reaction/widgets/reaction_circle.dart';
import 'package:quiz/ui/quiz/etc/reaction/widgets/replay_dialog.dart';

class ReactionRateScreen extends ConsumerStatefulWidget {
  static String routeName = 'reaction';
  const ReactionRateScreen({super.key});

  @override
  ConsumerState<ReactionRateScreen> createState() =>
      _ReactionRateScreenState();
}

class _ReactionRateScreenState
    extends ConsumerState<ReactionRateScreen> {
  int? startTime;
  int count = 1;
  String label = '';
  List<int> resultList = [];
  bool isGreen = false;

  Future<void> countRandomTime() async {
    await Future.delayed(Duration(milliseconds: _setRandomTime()));
    startTime = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      isGreen = true;
    });
  }

  // 2~4초 사이의 랜덤 시간 설정
  int _setRandomTime() {
    return Random().nextInt(2000) + 2000;
  }

  @override
  void initState() {
    super.initState();
    countRandomTime();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(adFinishedProvider, (p, n) async {
      if (n == true) {
        resetScreen();
        await countRandomTime();
        ref.read(adFinishedProvider.notifier).onReset();
      }
    });

    final isStepOver = isGreen && label.isNotEmpty; // 단계 끝
    final isGameOver = count == 5 && label.isNotEmpty; // 게임 끝

    return DefaultLayout(
      needWillPopScope: true,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// AppBar
              ReactionAppBar(onTapBack: onTapBack, count: count),
              QuizDetailLayout(
                /// Body
                body: isGameOver
                    ? ReactionAverageBox(testResults: resultList)
                    : ReactionCircle(
                        onTapCircle: onTapCircle,
                        isGreen: isGreen,
                        label: label,
                      ),

                /// Footer
                footer: PrimaryButton(
                  label: isGameOver ? '다시 시작' : '다음',
                  onPressed: isStepOver
                      ? isGameOver
                            ? shoReplayDialog
                            : onTapNext
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onTapBack() {
    showDialog(
      context: context,
      builder: (context) => ExitDialog(
        onTapConfirm: () {
          context.pop();
          // resetScreen();
          context.goNamed(HomeScreen.routeName);
        },
      ),
    );
  }

  void onTapCircle() {
    if (isGreen && label.isNotEmpty) return;
    if (startTime != null) {
      int reactionTime =
          DateTime.now().millisecondsSinceEpoch - startTime!;
      // 50ms만큼 임의의 상향조정
      int result = reactionTime >= 51
          ? reactionTime - 50
          : reactionTime;

      setState(() {
        label = '$result ms';
        resultList = [...resultList, result];
      });
    } else {
      setState(() {
        label = '너무 빨리 눌렀습니다!';
        count = 0;
        isGreen = true;
        resultList = [];
      });
    }
    startTime = null;
  }

  void onTapNext() {
    setState(() {
      isGreen = false;
      label = '';
      count = count + 1;
      startTime = null;
      countRandomTime();
    });
  }

  void shoReplayDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return RecationReplayDialog(onTapReplay: _onTapReplay);
      },
    );
  }

  void _onTapReplay() {
    context.pop();
    ref.read(interstitialAdViewModelProvider.notifier).showAd();
  }

  void resetScreen() {
    setState(() {
      isGreen = false;
      count = 1;
      label = '';
      startTime = null;
      resultList = [];
    });
  }
}
