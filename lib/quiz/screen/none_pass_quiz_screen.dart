import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz/common/theme/layout.dart';
import 'package:quiz/quiz/screen/responsive_quiz_screen.dart';

import '../../common/component/primary_button.dart';
import '../../common/model/pagination_model.dart';
import '../../common/provider/selected_quiz_provider.dart';
import '../../time/provider/timer_provider.dart';
import '../component/quiz_detail_card.dart';
import '../model/quiz_item_model.dart';
import '../provider/quiz_item_provider.dart';
import 'default_quiz_screen.dart';

class NonePassQuizScreen extends ConsumerWidget {
  final PageController pageController;
  final int remainingSeconds;
  final VoidCallback onNextPressed;
  final VoidCallback onPrevPressed;
  final VoidCallback showAnswerPressed;

  const NonePassQuizScreen({
    super.key,
    required this.pageController,
    required this.remainingSeconds,
    required this.onNextPressed,
    required this.onPrevPressed,
    required this.showAnswerPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedQuiz = ref.watch(selectedQuizProvider);
    final data = ref.watch(quizItemProvider('${selectedQuiz!.id}'));
    final showAnswer = ref.watch(showAnswerProvider);
    final currentIndex = ref.watch(currentIndexProvider);

    data as QuizPagination<QuizItemModel>;
    return ResponsiveQuizScreen(
      body: _Body(
        data: data,
        pageController: pageController,
        showAnswer: showAnswer,
        onPageChanged: (index) => onPageChanged(index, ref),
      ),
      footer: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _AnswerBox(
            showAnswer: showAnswer,
            answer: data.models[currentIndex].answer,
          ),
          _TimeOver(remainingSeconds: remainingSeconds),
          _Footer(
            onPrevPressed: currentIndex == 0 ? null : onPrevPressed,
            showAnswerPressed: showAnswerPressed,
            onNextPressed:
            currentIndex + 1 == data.models.length ? null : onNextPressed,
          ),
        ],
      ),
    );

  }

  void onPageChanged(int index, WidgetRef ref) {
    ref.read(currentIndexProvider.notifier).state = index;
  }
}

class _Body extends StatelessWidget {
  final QuizPagination<QuizItemModel> data;
  final PageController pageController;
  final bool showAnswer;
  final void Function(int) onPageChanged;
  const _Body({
    super.key,
    required this.data,
    required this.pageController,
    required this.showAnswer,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: onPageChanged,
        children: List.generate(
          data.models.length,
          (index) {
            final model = data.models[index];

            return QuizDetailCard.fromModel(model: model);
          },
        ),
      ),
    );
  }
}

class _TimeOver extends StatelessWidget {
  final int remainingSeconds;
  const _TimeOver({
    super.key,
    required this.remainingSeconds,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        remainingSeconds == 0 ? '💣 TIME OVER 💣' : "",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 32,
          fontFamily: 'Roboto',
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final VoidCallback? onPrevPressed;
  final VoidCallback? showAnswerPressed;
  final VoidCallback? onNextPressed;
  const _Footer({
    super.key,
    required this.onPrevPressed,
    required this.showAnswerPressed,
    required this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
    return context.layout(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PrimaryButton(
            label: '◀️ 이전',
            onPressed: onPrevPressed,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: PrimaryButton(
              label: '정답',
              onPressed: showAnswerPressed,
            ),
          ),
          const SizedBox(width: 8),
          PrimaryButton(
            label: '다음 ▶️',
            onPressed: onNextPressed,
          ),
        ],
      ),
      desktop: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: '◀️ 이전',
                  onPressed: onPrevPressed,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: PrimaryButton(
                  label: '다음 ▶️',
                  onPressed: onNextPressed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: '정답',
            onPressed: showAnswerPressed,
          ),
        ],
      ),
    );
  }
}

class _AnswerBox extends StatelessWidget {
  final bool showAnswer;
  final String answer;
  const _AnswerBox({
    super.key,
    required this.showAnswer,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      showAnswer ? 'A.$answer' : '',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: context.layout(48, mobile: 24),
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
