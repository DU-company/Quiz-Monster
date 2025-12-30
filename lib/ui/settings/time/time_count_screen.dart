import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_monster/core/provider/selected_quiz_provider.dart';
import 'package:quiz_monster/core/theme/theme_provider.dart';
import 'package:quiz_monster/ui/quiz/etc/liar/liar_screen.dart';
import 'package:quiz_monster/ui/common/layout/default_layout.dart';
import 'package:quiz_monster/ui/quiz/etc/reaction/reaction_rate_screen.dart';
import 'package:quiz_monster/ui/quiz/detail/quiz_detail_screen.dart';
import 'package:quiz_monster/ui/quiz/detail/view_model/quiz_detail_view_model.dart';
import 'package:quiz_monster/ui/settings/time/set_time_view_model.dart';

class TimeCountScreen extends ConsumerStatefulWidget {
  static String routeName = 'time-count';

  const TimeCountScreen({super.key});
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
      context.goNamed(
        QuizDetailScreen.routeName,
        pathParameters: {'qid': selectedModel.id.toString()},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.read(themeServiceProvider);
    final selectedQuiz = ref.watch(selectedQuizProvider);
    ref.watch(timeViewModelProvider);
    ref.watch(quizDetailViewModelProvider(selectedQuiz!.id));

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
                _currentNumber == -1
                    ? "START!"
                    : _currentNumber.toString(),
                style: theme.typo.headline1.copyWith(fontSize: 60),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_currentNumber != -1)
            Text('게임이 곧 시작됩니다...', style: theme.typo.subtitle1),
        ],
      ),
    );
  }
}
