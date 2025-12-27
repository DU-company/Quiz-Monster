import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz/core/theme/theme_provider.dart';
import 'package:quiz/data/models/quiz_detail_model.dart';
import 'package:quiz/ui/common/screens/home_screen.dart';
import 'package:quiz/ui/common/widgets/primary_button.dart';
import 'package:quiz/ui/common/layout/default_layout.dart';
import 'package:quiz/ui/quiz/detail/widgets/exit_dialog.dart';
import 'package:quiz/ui/quiz/etc/liar/liar_view_model.dart';
import 'package:quiz/ui/quiz/etc/liar/widgets/answer_dialog.dart';
import 'package:quiz/ui/settings/player/player_view_model.dart';
import 'package:quiz/core/provider/page_controller_provider.dart';
import 'package:quiz/ui/quiz/detail/widgets/quiz_detail_success_view.dart';

class LiarGameScreen extends ConsumerWidget {
  static String routeName = 'liar';

  final List<QuizDetailModel> items;
  const LiarGameScreen(this.items);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// State
    final liarIndex = ref.watch(liarViewModelProvider);
    final playerCount = ref.watch(playerViewModelProvider);
    final currentIndex = ref.watch(currentIndexProvider);

    final pageController = ref.watch(pageControllerProvider);

    /// Boolean
    final showAnswer = ref.watch(showAnswerProvider);
    final isLastPage = currentIndex >= playerCount;
    final isBeforeLastPage = currentIndex + 1 >= playerCount;

    return DefaultLayout(
      needWillPopScope: true,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _AppBar(
                label: isLastPage ? '' : 'PLAYER ${currentIndex + 1}',
                onBackPressed: () => onBackPressed(context, ref),
              ),
              Spacer(),
              _Body(
                pageController: pageController,
                playerCount: playerCount,
                showAnswer: showAnswer,
                liarIndex: liarIndex,
                items: items,
              ),
              const SizedBox(height: 16),
              Center(
                child: PrimaryButton(
                  label: isLastPage ? '정답 보기' : '단어 보기',
                  onPressed: (isLastPage && showAnswer)
                      ? null
                      : isLastPage
                      ? () => showAnswerDialog(context, ref)
                      : () => onTapAnswer(ref),
                ),
              ),

              Spacer(),
              _Footer(
                isBeforeLastPage: isBeforeLastPage,
                onNext: (isLastPage || !showAnswer)
                    ? null
                    : () => onNext(ref, pageController),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showAnswerDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AnswerDialog(
        showAnswer: () {
          context.pop();
          ref.read(showAnswerProvider.notifier).state = true;
        },
      ),
    );
  }

  void onTapAnswer(WidgetRef ref) {
    ref.read(showAnswerProvider.notifier).state = true;
  }

  void onNext(WidgetRef ref, PageController controller) {
    ref.read(showAnswerProvider.notifier).state = false;
    ref
        .read(currentIndexProvider.notifier)
        .update((index) => index + 1);
    ref.read(pageControllerProvider.notifier).nextPage();
  }

  void onBackPressed(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => ExitDialog(
        onTapConfirm: () {
          ref.read(currentIndexProvider.notifier).state = 0;
          ref.read(showAnswerProvider.notifier).state = false;
          context.goNamed(HomeScreen.routeName);
        },
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  final String label;
  final VoidCallback onBackPressed;
  const _AppBar({
    super.key,
    required this.label,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(label),
      leading: IconButton(
        onPressed: onBackPressed,
        icon: Icon(Icons.arrow_back_ios),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  final PageController pageController;
  final int playerCount;
  final bool showAnswer;
  final int liarIndex;
  final List<QuizDetailModel> items;
  const _Body({
    super.key,
    required this.pageController,
    required this.playerCount,
    required this.showAnswer,
    required this.liarIndex,
    required this.items,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(themeServiceProvider);

    return Expanded(
      child: PageView.builder(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        itemCount: playerCount + 1,
        itemBuilder: (context, index) {
          final model = items.first;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  index == playerCount
                      ? '자유롭게 토론을 진행하세요!'
                      : '혼자만 보세요!',
                  style: theme.typo.headline6,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        showAnswer
                            ? index == liarIndex
                                  ? '당신은 라이어 입니다.\n있는 힘 껏 아는 척을 해 주세요.'
                                  : model.answer
                            : '',
                        textAlign: TextAlign.center,
                        style: theme.typo.headline6.copyWith(
                          color: theme.color.secondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final bool isBeforeLastPage;
  final VoidCallback? onNext;

  const _Footer({
    super.key,
    required this.isBeforeLastPage,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          isBeforeLastPage ? "" : '⬇누르고 옆 사람에게 전달⬇',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 8),
        PrimaryButton(
          label: isBeforeLastPage ? '게임 시작' : '다음 사람',
          onPressed: onNext,
        ),
      ],
    );
  }
}
