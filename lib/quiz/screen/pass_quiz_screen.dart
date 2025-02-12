import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz/common/theme/layout.dart';
import 'package:quiz/quiz/screen/default_quiz_screen.dart';
import 'package:quiz/quiz/screen/result_screen.dart';
import '../../common/component/primary_button.dart';
import '../../common/model/pagination_model.dart';
import '../../common/provider/selected_quiz_provider.dart';
import '../../setting/provider/pass_provider.dart';
import '../model/quiz_item_model.dart';
import '../provider/quiz_item_provider.dart';

final passedWordProvider = StateProvider<List<String>>((ref) => []);
final correctWordProvider = StateProvider<List<String>>((ref) => []);

class PassQuizScreen extends ConsumerWidget {
  final PageController pageController;
  final int remainingSeconds;

  const PassQuizScreen({
    super.key,
    required this.pageController,
    required this.remainingSeconds,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passCount = ref.watch(passProvider);
    final selectedQuiz = ref.watch(selectedQuizProvider);
    final data = ref.watch(quizItemProvider('${selectedQuiz!.id}'));
    final currentIndex = ref.watch(currentIndexProvider);
    final isGameOver = remainingSeconds == 0 || currentIndex == 30;

    data as QuizPagination<QuizItemModel>;
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              itemCount: data.models.length + 1,
              itemBuilder: (context, index) {
                if (index == data.models.length) {
                  return Text('');
                }
                final model = data.models[index];
                return Center(
                  child: Text(
                    '- ${model.answer} -',
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
            onNext: () => onNext(ref, data.models[currentIndex].answer),
            onPass: () => onPass(ref, data.models[currentIndex].answer),
          )
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
    ref.read(passProvider.notifier).update((state) => state = state - 1);
    ref.read(passedWordProvider.notifier).update(
          (state) => state = [...state, word],
        );
  }

  void onNext(WidgetRef ref, String word) {
    ref.read(correctWordProvider.notifier).update(
          (state) => state = [...state, word],
        );
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
            fontColor: Colors.black,
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
        )
      ],
    );
  }
}
