import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quiz/ad/provider/ad_count_provider.dart';
import 'package:quiz/ad/provider/interstitial_ad_provider.dart';
import 'package:quiz/common/provider/selected_quiz_provider.dart';
import 'package:quiz/common/screen/default_layout.dart';
import 'package:quiz/etc/screen/reaction_rate_screen.dart';
import 'package:quiz/quiz/screen/default_quiz_screen.dart';

import '../../quiz/provider/quiz_item_provider.dart';

class TimeCountScreen extends ConsumerStatefulWidget {
  static String routeName = '/timeCount';

  const TimeCountScreen({
    super.key,
  });
  @override
  _TimeCountScreenState createState() => _TimeCountScreenState();
}

class _TimeCountScreenState extends ConsumerState<TimeCountScreen>
    with SingleTickerProviderStateMixin {
  int _currentNumber = 3;
  double _opacity = 1.0;
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _playBeepSound() async {
    await _player.play(AssetSource('beep.mp3')); // 효과음 파일 추가 필요
  }

  void _startCountdown() {
    _playBeepSound(); // 효과음 재생

    Future.delayed(Duration(milliseconds: 1000), () {
      _changeNumber(2);
    });
    Future.delayed(Duration(milliseconds: 2000), () {
      _changeNumber(1);
    });
    Future.delayed(Duration(milliseconds: 3000), () {
      _changeNumber(0); // "Start!" 표시
    });
    Future.delayed(Duration(milliseconds: 4000), () {
      _goToQuizScreen(); // 퀴즈 화면 이동
    });
  }

  void _changeNumber(int num) {
    setState(() {
      _opacity = 0.0; // 먼저 페이드아웃
    });
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _currentNumber = num == 0 ? -1 : num;
        _opacity = 1.0; // 다시 페이드인
      });
      // if (num > 0)
    });
  }

  void _goToQuizScreen() {
    final selectedModel = ref.read(selectedQuizProvider);
    if (selectedModel!.title == '반응속도 테스트') {
      context.goNamed(ReactionRateScreen.routeName);
    } else {
      context.goNamed(DefaultQuizScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedQuiz = ref.watch(selectedQuizProvider);

    ref.watch(quizItemProvider('${selectedQuiz!.id}'));

    return DefaultLayout(
      needWillPopScope: true,
      backgroundColor: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: _opacity,
              child: Text(
                _currentNumber == -1 ? "START!" : _currentNumber.toString(),
                style: TextStyle(
                  fontSize: 80,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_currentNumber != -1)
            Text(
              '게임이 곧 시작됩니다...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
        ],
      ),
    );
  }
}
