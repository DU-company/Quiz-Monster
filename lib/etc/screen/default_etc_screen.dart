import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz/ui/pagination/pagination_screen.dart';
import 'package:quiz/ui/common/widgets/primary_button.dart';
import 'package:quiz/data/models/pagination_state.dart';
import 'package:quiz/core/service/selected_quiz_provider.dart';
import 'package:quiz/ui/common/layout/default_layout.dart';
import 'package:quiz/etc/provider/player_provider.dart';
import 'package:quiz/home/screen/home_screen.dart';
import 'package:quiz/quiz/model/quiz_item_model.dart';
import 'package:quiz/quiz/provider/page_controller_provider.dart';
import 'package:quiz/quiz/provider/quiz_item_provider.dart';
import 'package:quiz/quiz/screen/default_quiz_screen.dart';

import '../../ui/common/widgets/custom_bottom_sheet.dart';

final liarProvider = Provider.autoDispose<int>((ref) {
  final playerCount = ref.watch(playerProvider);
  final Random random = Random();
  final liarIndex = random.nextInt(playerCount);
  return liarIndex;
});

class DefaultEtcScreen extends ConsumerWidget {
  static String routeName = 'etc';
  const DefaultEtcScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showAnswer = ref.watch(showAnswerProvider);
    final pageController = ref.watch(pageControllerProvider);
    final playerCount = ref.watch(playerProvider);
    final liarIndex = ref.watch(liarProvider);
    final currentIndex = ref.watch(currentIndexProvider);
    final selectedQuiz = ref.watch(selectedQuizProvider);
    final data = ref.watch(quizItemProvider('${selectedQuiz!.id}'));
    final isLastPage = currentIndex >= playerCount;
    final isBeforeLastPage = currentIndex + 1 >= playerCount;

    if (data is PaginationSuccess<QuizItemModel>) {
      return DefaultLayout(
        needWillPopScope: true,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _AppBar(
                  label: isLastPage
                      ? ''
                      : 'PLAYER ${currentIndex + 1}',
                  onBackPressed: () => onBackPressed(context, ref),
                ),
                Spacer(),
                _Body(
                  pageController: pageController,
                  playerCount: playerCount,
                  showAnswer: showAnswer,
                  liarIndex: liarIndex,
                  data: data,
                ),
                const SizedBox(height: 16),
                _AnswerButton(
                  label: isLastPage ? '정답 보기' : '단어 보기',
                  onAnswerPressed: (isLastPage && showAnswer)
                      ? null
                      : () =>
                            onAnswerPressed(ref, isLastPage, context),
                ),
                Spacer(),
                _Footer(
                  label: isBeforeLastPage ? "" : '⬇누르고 옆 사람에게 전달⬇',
                  buttonLabel: isBeforeLastPage ? '게임 시작' : '다음 사람',
                  onNext: isLastPage
                      ? null
                      : () => onNext(ref, pageController),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return PaginationScreen(data: data);
  }

  void onAnswerPressed(
    WidgetRef ref,
    bool isLastPage,
    BuildContext context,
  ) {
    if (isLastPage) {
      showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return CustomBottomSheet(
            title: '정답을 확인하시겠습니까?',
            desc: '',
            label: '아니오',
            redLabel: '정답 보기',
            height: 160,
            onRedPressed: () {
              context.pop();
              ref.read(showAnswerProvider.notifier).state = true;
            },
            onPressed: () => context.pop(),
          );
        },
      );
    } else {
      ref.read(showAnswerProvider.notifier).state = true;
    }
  }

  void onNext(WidgetRef ref, PageController controller) {
    ref.read(showAnswerProvider.notifier).state = false;
    ref
        .read(currentIndexProvider.notifier)
        .update((index) => index + 1);
    controller.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }

  void onBackPressed(BuildContext context, WidgetRef ref) {
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
            ref.read(currentIndexProvider.notifier).state = 0;
            ref.read(showAnswerProvider.notifier).state = false;
            context.goNamed(HomeScreen.routeName);
          },
        );
      },
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          style: IconButton.styleFrom(foregroundColor: Colors.white),
          onPressed: onBackPressed,
          icon: Icon(Icons.arrow_back_ios),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
            fontSize: 32,
          ),
        ),
        SizedBox(width: 32),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final PageController pageController;
  final int playerCount;
  final bool showAnswer;
  final int liarIndex;
  final PaginationSuccess<QuizItemModel> data;
  const _Body({
    super.key,
    required this.pageController,
    required this.playerCount,
    required this.showAnswer,
    required this.liarIndex,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView.builder(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        itemCount: playerCount + 1,
        itemBuilder: (context, index) {
          final model = data.items.first;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  index == playerCount
                      ? '설명을 시작하세요.'
                            '\n필요하면 토론 시간을 늘릴 수도 있습니다.'
                      : '혼자만 보세요',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: showAnswer
                        ? Center(
                            child: Text(
                              textAlign: TextAlign.center,
                              index == liarIndex
                                  ? '당신은 라이어 입니다.\n있는 힘 껏 아는 척을 해 주세요.'
                                  : model.answer,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                              ),
                            ),
                          )
                        : Text(''),
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

class _AnswerButton extends StatelessWidget {
  final VoidCallback? onAnswerPressed;
  final String label;
  const _AnswerButton({
    super.key,
    required this.onAnswerPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PrimaryButton(label: label, onPressed: onAnswerPressed),
    );
  }
}

class _Footer extends StatelessWidget {
  final String buttonLabel;
  final String label;
  final VoidCallback? onNext;

  const _Footer({
    super.key,
    required this.buttonLabel,
    required this.label,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 8),
        PrimaryButton(label: buttonLabel, onPressed: onNext),
      ],
    );
  }
}
