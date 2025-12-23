import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz/ad/provider/rewarded_ad_provider.dart';
import 'package:quiz/core/theme/responsive/layout.dart';
import 'package:quiz/core/theme/theme_provider.dart';
import 'package:quiz/data/models/quiz_detail_model.dart';
import 'package:quiz/ui/common/widgets/primary_button.dart';
import 'package:quiz/ui/quiz/detail/quiz_detail_success_view.dart';
import 'package:quiz/ui/result/result_screen.dart';
import 'package:quiz/ui/settings/pass/pass_view_model.dart';

final passedWordProvider = StateProvider<List<String>>((ref) => []);
final correctWordProvider = StateProvider<List<String>>((ref) => []);

class PassQuizScreen extends ConsumerWidget {
  final List<QuizDetailModel> items;
  final PageController pageController;
  final int remainingSeconds;

  const PassQuizScreen({
    super.key,
    required this.items,
    required this.pageController,
    required this.remainingSeconds,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(themeServiceProvider);
    final viewModel = ref.read(passViewModelProvider.notifier);

    /// state
    final passCount = ref.watch(passViewModelProvider);
    final currentIndex = ref.watch(currentIndexProvider);
    final rewardedAd = ref.watch(rewardedAdProvider);

    /// boolean
    final isGameOver = remainingSeconds == 0 || currentIndex == 30;

    return Expanded(
      child: Column(
        children: [
          const SizedBox(height: 8),
          if (rewardedAd != null)
            PrimaryButton(
              label: '광고 보고 패스 추가',
              onPressed: () => viewModel.showAd(),
            ),
          Expanded(
            child: PageView.builder(
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              itemCount: items.length + 1,
              itemBuilder: (context, index) {
                final lastItem = index == items.length;
                if (lastItem) {
                  return SizedBox();
                }
                final model = items[index];
                return Center(
                  child: Text(
                    '- ${model.answer} -',
                    textAlign: TextAlign.center,
                    style: theme.typo.headline6.copyWith(
                      fontSize: context.layout(48, mobile: 24),
                    ),
                  ),
                );
              },
              onPageChanged: (index) => onPageChanged(index, ref),
            ),
          ),
          if (isGameOver) _GameOver(),
          if (!isGameOver)
            _PassFooter(
              passCount: passCount,
              isGameOver: isGameOver,
              onNextPage: () => viewModel.onNextPage(
                pageController,
                items[currentIndex].answer,
              ),
              onPass: () => viewModel.onPass(
                pageController,
                items[currentIndex].answer,
              ),
            ),
        ],
      ),
    );
  }

  void onPageChanged(int index, WidgetRef ref) {
    ref.read(currentIndexProvider.notifier).state = index;
  }
}

///-----------------------------------------------------------------------------
class _GameOver extends ConsumerWidget {
  const _GameOver({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(themeServiceProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '💣 GAME OVER 💣',
          textAlign: TextAlign.center,
          style: theme.typo.headline1.copyWith(fontFamily: 'Roboto'),
        ),
        PrimaryButton(
          label: '결과 보기',
          onPressed: () => context.goNamed(ResultScreen.routeName),
        ),
      ],
    );
  }
}

class _PassFooter extends StatelessWidget {
  final int passCount;
  final bool isGameOver;
  final VoidCallback onPass;
  final VoidCallback onNextPage;

  const _PassFooter({
    super.key,
    required this.passCount,
    required this.isGameOver,
    required this.onPass,
    required this.onNextPage,
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
            onPressed: isGameOver ? null : onNextPage,
          ),
        ),
      ],
    );
  }
}
