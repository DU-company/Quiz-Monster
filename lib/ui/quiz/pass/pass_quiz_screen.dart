import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz/ad/provider/rewarded_ad_provider.dart';
import 'package:quiz/core/theme/responsive/layout.dart';
import 'package:quiz/data/models/quiz_detail_model.dart';
import 'package:quiz/ui/quiz/detail/quiz_detail_success_view.dart';
import 'package:quiz/ui/result/result_screen.dart';
import '../../common/widgets/primary_button.dart';
import '../../settings/pass/pass_provider.dart';

final passedWordProvider = StateProvider<List<String>>((ref) => []);
final correctWordProvider = StateProvider<List<String>>((ref) => []);

class PassQuizScreen extends ConsumerWidget {
  final PageController pageController;
  final int remainingSeconds;
  final List<QuizDetailModel> items;

  const PassQuizScreen({
    super.key,
    required this.items,
    required this.pageController,
    required this.remainingSeconds,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passCount = ref.watch(passProvider);
    // final selectedQuiz = ref.watch(selectedQuizProvider);
    // final data = ref.watch(quizItemProvider('${selectedQuiz!.id}'));
    final currentIndex = ref.watch(currentIndexProvider);
    final isGameOver = remainingSeconds == 0 || currentIndex == 30;
    final rewardedAd = ref.watch(rewardedAdProvider);

    return Expanded(
      child: Column(
        children: [
          const SizedBox(height: 8),
          if (rewardedAd != null)
            PrimaryButton(
              label: '광고 보고 패스 추가(15~30초)',
              onPressed: () {
                ref
                    .read(rewardedAdProvider.notifier)
                    .showAd(
                      () => ref
                          .read(passProvider.notifier)
                          .update((pass) => pass + 1),
                    );
              },
            ),
          Expanded(
            child: PageView.builder(
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              itemCount: items.length + 1,
              itemBuilder: (context, index) {
                if (index == items.length) {
                  return Text('');
                }
                final model = items[index];
                return Center(
                  child: Text(
                    '- ${model.answer} -',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: context.layout(52, mobile: 36),
                    ),
                  ),
                );
              },
              onPageChanged: (index) => onPageChanged(index, ref),
            ),
          ),
          if (isGameOver) _GameOver(),
          // if (!isGameOver)
          _PassFooter(
            passCount: passCount,
            isGameOver: isGameOver,
            onNext: () => onNext(ref, items[currentIndex].answer),
            onPass: () => onPass(ref, items[currentIndex].answer),
          ),
        ],
      ),
    );
  }

  void onPageChanged(int index, WidgetRef ref) {
    ref.read(currentIndexProvider.notifier).state = index;
  }

  void onPass(WidgetRef ref, String word) {
    pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.linear,
    );
    ref
        .read(passProvider.notifier)
        .update((state) => state = state - 1);
    ref
        .read(passedWordProvider.notifier)
        .update((state) => state = [...state, word]);
  }

  void onNext(WidgetRef ref, String word) {
    ref
        .read(correctWordProvider.notifier)
        .update((state) => state = [...state, word]);
    pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }
}

///-----------------------------------------------------------------------------
class _GameOver extends StatelessWidget {
  const _GameOver({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '💣 GAME OVER 💣',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontFamily: 'Roboto',
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          PrimaryButton(
            label: '결과 보기',
            onPressed: () {
              context.goNamed(ResultScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}

class _PassFooter extends StatelessWidget {
  final int passCount;
  final bool isGameOver;
  final VoidCallback onPass;
  final VoidCallback onNext;

  const _PassFooter({
    super.key,
    required this.passCount,
    required this.isGameOver,
    required this.onNext,
    required this.onPass,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PrimaryButton(
            foregroundColor: Colors.black,
            backgroundColor: Colors.orange,
            label: 'PASS : $passCount',
            onPressed: passCount == 0 || isGameOver ? null : onPass,
          ),
        ),
        const SizedBox(width: 64),
        Expanded(
          child: PrimaryButton(
            label: 'NEXT ▶',
            onPressed: isGameOver ? null : onNext,
          ),
        ),
      ],
    );
  }
}
