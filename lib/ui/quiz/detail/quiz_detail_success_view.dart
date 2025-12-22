import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz/data/models/quiz_detail_model.dart';
import 'package:quiz/ui/common/screens/home_screen.dart';
import 'package:quiz/core/service/selected_quiz_provider.dart';
import 'package:quiz/ui/common/layout/default_layout.dart';
import 'package:quiz/quiz/provider/page_controller_provider.dart';
import 'package:quiz/etc/screen/fly_screen.dart';
import 'package:quiz/ui/quiz/no_pass/none_pass_quiz_screen.dart';
import 'package:quiz/ui/quiz/pass/pass_quiz_screen.dart';
import 'package:quiz/ui/quiz/detail/timer_provider.dart';
import 'package:quiz/ui/quiz/detail/widgets/detail_app_bar.dart';
import 'package:quiz/ui/settings/level/level_provider.dart';
import 'package:quiz/ui/settings/time/time_provider.dart';

final showAnswerProvider = StateProvider.autoDispose<bool>(
  (ref) => false,
);

final currentIndexProvider = StateProvider<int>((ref) => 0);

class QuizDetailSuccessView extends ConsumerStatefulWidget {
  final List<QuizDetailModel> items;
  const QuizDetailSuccessView(this.items);

  @override
  ConsumerState<QuizDetailSuccessView> createState() =>
      _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizDetailSuccessView>
    with SingleTickerProviderStateMixin {
  final AudioPlayer player = AudioPlayer();
  late AnimationController animationController;

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
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedQuiz = ref.watch(selectedQuizProvider);
    final showAnswer = ref.watch(showAnswerProvider);
    final currentIndex = ref.watch(currentIndexProvider);
    final remainingSeconds = ref.watch(timerProvider);
    final pageController = ref.watch(pageControllerProvider);

    if (!showAnswer && remainingSeconds == 3) {
      playSound();
    }
    return DefaultLayout(
      needWillPopScope: true,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8,
          ),
          child: Column(
            children: [
              DetailAppBar(
                length: widget.items.length,
                currentIndex: currentIndex,
                animationController: animationController,
                remainingSeconds: remainingSeconds,
                onTapComfrim: onTapConfirm,
              ),

              /// Pass
              if (selectedQuiz!.hasPass && !selectedQuiz.isEtc)
                PassQuizScreen(
                  items: widget.items,
                  pageController: pageController,
                  remainingSeconds: remainingSeconds,
                ),

              /// NoPass
              if (!selectedQuiz.hasPass && !selectedQuiz.isEtc)
                NonePassQuizScreen(
                  items: widget.items,
                  remainingSeconds: remainingSeconds,
                  pageController: pageController,
                  onNextPressed: onNextPressed,
                  onPrevPressed: onPrevPressed,
                  showAnswerPressed: showAnswerPressed,
                ),

              /// ETC
              if (selectedQuiz.title == '나는야 아나운서' ||
                  selectedQuiz.title == '훈민정음')
                NonePassQuizScreen(
                  items: widget.items,
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

  void playSound() async {
    await player.play(
      AssetSource('three_counts.mp3'),
    ); // 효과음 파일 추가 필요
  }

  void stopSound() {
    player.stop();
  }

  void restartAnimation() {
    animationController.reset();
    animationController.forward();
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

  // pop
  void onTapConfirm() {
    // pop dialog
    context.pop();
    ref.read(showAnswerProvider.notifier).state = false;
    ref.read(levelProvider.notifier).state = null;
    stopSound();
    ref.read(currentIndexProvider.notifier).state = 0;

    context.goNamed(HomeScreen.routeName);
  }
}
