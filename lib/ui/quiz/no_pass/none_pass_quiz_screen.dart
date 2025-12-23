import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz/core/theme/responsive/layout.dart';
import 'package:quiz/data/entities/quiz_detail_entity.dart';
import 'package:quiz/data/models/quiz_detail_model.dart';
import 'package:quiz/ui/common/layout/quiz_detail_layout.dart';
import '../../common/widgets/primary_button.dart';
import '../detail/widgets/quiz_detail_card.dart';
import '../detail/widgets/quiz_detail_success_view.dart';

class NonePassQuizScreen extends ConsumerWidget {
  final PageController pageController;
  final int remainingSeconds;
  final VoidCallback onNextPressed;
  final VoidCallback onPrevPressed;
  final VoidCallback showAnswerPressed;
  final List<QuizDetailModel> items;

  const NonePassQuizScreen({
    super.key,
    required this.pageController,
    required this.remainingSeconds,
    required this.onNextPressed,
    required this.onPrevPressed,
    required this.showAnswerPressed,
    required this.items,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showAnswer = ref.watch(showAnswerProvider);
    final currentIndex = ref.watch(currentIndexProvider);
    return QuizDetailLayout(
      body: _Body(
        items: items,
        pageController: pageController,
        showAnswer: showAnswer,
        onPageChanged: (index) => onPageChanged(index, ref),
      ),
      footer: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _AnswerBox(
            showAnswer: showAnswer,
            answer: items[currentIndex].answer,
          ),
          _TimeOver(remainingSeconds: remainingSeconds),
          _Footer(
            onPrevPressed: currentIndex == 0 ? null : onPrevPressed,
            showAnswerPressed: showAnswerPressed,
            onNextPressed: currentIndex + 1 == items.length
                ? null
                : onNextPressed,
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
  final List<QuizDetailModel> items;
  final PageController pageController;
  final bool showAnswer;
  final void Function(int) onPageChanged;
  const _Body({
    super.key,
    required this.items,
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
        children: List.generate(items.length, (index) {
          final model = items[index];

          return QuizDetailCard(detail: model);
        }),
      ),
    );
  }
}

class _TimeOver extends StatelessWidget {
  final int remainingSeconds;
  const _TimeOver({super.key, required this.remainingSeconds});

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
          PrimaryButton(label: '◀️ 이전', onPressed: onPrevPressed),
          const SizedBox(width: 8),
          Expanded(
            child: PrimaryButton(
              label: '정답',
              onPressed: showAnswerPressed,
            ),
          ),
          const SizedBox(width: 8),
          PrimaryButton(label: '다음 ▶️', onPressed: onNextPressed),
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
          PrimaryButton(label: '정답', onPressed: showAnswerPressed),
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
