import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz/ui/common/widgets/custom_bottom_sheet.dart';
import 'package:quiz/ui/pagination/pagination_screen.dart';
import 'package:quiz/data/models/pagination_state.dart';
import 'package:quiz/core/service/selected_quiz_provider.dart';
import 'package:quiz/ui/common/layout/default_layout.dart';
import 'package:quiz/home/screen/home_screen.dart';
import 'package:quiz/quiz/model/quiz_item_model.dart';
import 'package:quiz/quiz/provider/page_controller_provider.dart';
import 'package:quiz/quiz/provider/quiz_item_provider.dart';
import 'package:quiz/etc/screen/fly_screen.dart';
import 'package:quiz/quiz/screen/none_pass_quiz_screen.dart';
import 'package:quiz/quiz/screen/pass_quiz_screen.dart';
import 'package:quiz/time/provider/time_provider.dart';
import '../../core/utils/data_utils.dart';
import '../../setting/provider/level_provider.dart';
import '../../time/provider/timer_provider.dart';

final showAnswerProvider = StateProvider<bool>(
  (ref) => false,
);

final currentIndexProvider = StateProvider<int>((ref) => 0);

class DefaultQuizScreen extends ConsumerStatefulWidget {
  static String routeName = 'quiz';

  const DefaultQuizScreen({super.key});

  @override
  ConsumerState<DefaultQuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<DefaultQuizScreen>
    with SingleTickerProviderStateMixin {
  final AudioPlayer player = AudioPlayer();
  late AnimationController animationController;

  void playSound() async {
    await player.play(AssetSource('three_counts.mp3')); // 효과음 파일 추가 필요
  }

  void stopSound() async {
    player.stop();
  }

  @override
  void initState() {
    final time = ref.read(timeProvider);
    animationController = AnimationController(
      vsync: this,
      duration: time,
    )..forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();

    player.dispose(); // 위젯이 삭제될 때 정리
    super.dispose();
  }

  void restartAnimation() {
    animationController.reset();
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final selectedQuiz = ref.watch(selectedQuizProvider);
    final data = ref.watch(quizItemProvider('${selectedQuiz!.id}'));
    final showAnswer = ref.watch(showAnswerProvider);
    final currentIndex = ref.watch(currentIndexProvider);
    final remainingSeconds = ref.watch(timerProvider); // 상태 감시
    final pageController = ref.watch(pageControllerProvider);

    if (data is PaginationSuccess<QuizItemModel>) {
      if (!showAnswer && remainingSeconds == 3) {
        playSound();
      }
      return DefaultLayout(
        needWillPopScope: true,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _CustomAppBar(
                  length: data.items.length,
                  currentIndex: currentIndex,
                  animationController: animationController,
                  remainingSeconds: remainingSeconds,
                  onRedPressed: onRedPressed,
                ),
                if (selectedQuiz.pass && !selectedQuiz.isEtc!)
                  PassQuizScreen(
                    pageController: pageController,
                    remainingSeconds: remainingSeconds,
                  ),
                if (!selectedQuiz.pass && !selectedQuiz.isEtc!)
                  NonePassQuizScreen(
                    remainingSeconds: remainingSeconds,
                    pageController: pageController,
                    onNextPressed: onNextPressed,
                    onPrevPressed: onPrevPressed,
                    showAnswerPressed: showAnswerPressed,
                  ),
                if (selectedQuiz.title == '나는야 아나운서' ||
                    selectedQuiz.title == '훈민정음')
                  NonePassQuizScreen(
                    remainingSeconds: remainingSeconds,
                    pageController: pageController,
                    onNextPressed: onNextPressed,
                    onPrevPressed: onPrevPressed,
                    showAnswerPressed: showAnswerPressed,
                  ),
                if (selectedQuiz.title == '파리가 몇 마리?')
                  FlyScreen(
                    showAnswerPressed: showAnswerPressed,
                    onReplay: onReplay,
                    remainingSeconds: remainingSeconds,
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return PaginationScreen(data: data);
  }

  void allStop() {
    stopSound();
    animationController.stop();
    ref.read(timerProvider.notifier).stopTimer();
    ref.read(showAnswerProvider.notifier).state = false;
  }

  void onPrevPressed() {
    ref.read(pageControllerProvider.notifier).previousPage();
    // ref.read(currentIndexProvider.notifier).update((state) => state - 1);

    allStop();
  }

  /// 파리가 몇 마리?
  void onReplay() {
    stopSound();
    restartAnimation();
    ref.read(showAnswerProvider.notifier).state = false;
    ref.read(timerProvider.notifier).restartTimer();
  }

  void onNextPressed() {
    onReplay();
    ref.read(pageControllerProvider.notifier).nextPage();
  }

  void showAnswerPressed() {
    allStop();
    ref.read(showAnswerProvider.notifier).state = true;
  }

  void onRedPressed() {
    context.pop(); // hide bottom sheet
    ref.read(showAnswerProvider.notifier).state = false; // hide answer
    ref.read(levelProvider.notifier).state = null; // reset level
    stopSound();
    ref.read(currentIndexProvider.notifier).state = 0;

    context.goNamed(HomeScreen.routeName);
  }
}

/// --------------------------------------------------------------------------

class _CustomAppBar extends StatelessWidget {
  final int length;
  final AnimationController animationController;
  final int remainingSeconds;
  final int currentIndex;
  final VoidCallback onRedPressed;
  const _CustomAppBar({
    super.key,
    required this.length,
    required this.currentIndex,
    required this.animationController,
    required this.remainingSeconds,
    required this.onRedPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => onBackPressed(context),
          style: IconButton.styleFrom(
            foregroundColor: Colors.white,
          ),
          icon: Icon(
            Icons.arrow_back_ios,
          ),
        ),
        AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return Stack(children: [
              SizedBox(
                height: 52,
                width: 52,
                child: CircularProgressIndicator(
                  value: animationController.value, // 0 → 1 (5초 동안 증가)
                  strokeWidth: 4.5,
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Text(
                    DataUtils.formatTime(remainingSeconds),
                    // textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ]);
          },
        ),
        if (length == 0) SizedBox(width: 32),
        if (length != 0)
          Text(
            currentIndex == length
                ? '$length/$length'
                : '${currentIndex + 1}/$length',
            style: TextStyle(color: Colors.white),
          ),
      ],
    );
  }

  void onBackPressed(BuildContext context) {
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
          onPressed: () {
            context.pop(); // hide bottom sheet
          },
          onRedPressed: onRedPressed,
        );
      },
    );
  }
}
