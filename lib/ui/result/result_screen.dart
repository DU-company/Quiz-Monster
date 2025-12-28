import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_monster/core/theme/theme_provider.dart';
import 'package:quiz_monster/ui/common/screens/home_screen.dart';
import 'package:quiz_monster/ui/common/widgets/primary_button.dart';
import 'package:quiz_monster/ui/common/layout/default_layout.dart';
import 'package:quiz_monster/core/theme/responsive/layout.dart';
import 'package:quiz_monster/ui/quiz/detail/widgets/quiz_detail_success_view.dart';
import 'package:quiz_monster/ui/quiz/pass/pass_quiz_screen.dart';

class ResultScreen extends ConsumerWidget {
  static String routeName = 'result';
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);
    final correctWords = ref.watch(correctWordProvider);
    final passedWords = ref.watch(passedWordProvider);

    return DefaultLayout(
      needWillPopScope: true,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: context.layout(
            /// mobile과 Tablet은 세로로 배치
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: kToolbarHeight),
                        _Top(
                          passedWords: passedWords,
                          currentIndex: currentIndex,
                        ),
                        Divider(),
                        _Body(
                          passedWords: passedWords,
                          correctWords: correctWords,
                        ),
                      ],
                    ),
                  ),
                ),
                _Footer(onPressed: () => onPressed(context, ref)),
              ],
            ),

            /// Desktop은 가로로 1:1 배치
            desktop: Row(
              children: [
                Expanded(
                  child: _Top(
                    passedWords: passedWords,
                    currentIndex: currentIndex,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _Body(
                        passedWords: passedWords,
                        correctWords: correctWords,
                      ),
                      _Footer(
                        onPressed: () => onPressed(context, ref),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onPressed(BuildContext context, WidgetRef ref) {
    ref.read(passedWordProvider.notifier).state = [];
    context.goNamed(HomeScreen.routeName);
    ref.read(currentIndexProvider.notifier).state = 0;
  }
}

class _Top extends ConsumerWidget {
  final List<String> passedWords;
  final int currentIndex;

  const _Top({
    super.key,
    required this.passedWords,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(themeServiceProvider);
    final TextStyle ts = theme.typo.headline3.copyWith(
      fontSize: 28,
      fontFamily: 'Roboto',
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/img/wow.png',
          height: 100,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 16),
        SvgPicture.asset(
          'assets/img/eyes1.svg',
          height: 100,
          fit: BoxFit.cover,
        ),

        const SizedBox(height: 16),
        Text(
          'YOUR SCORE IS',
          textAlign: TextAlign.center,
          style: ts.copyWith(fontWeight: FontWeight.w300),
        ),
        const SizedBox(height: 16),
        Text(
          '${currentIndex - passedWords.length}/30',
          textAlign: TextAlign.center,
          style: ts.copyWith(fontSize: 48),
        ),
      ],
    );
  }
}

class _WordBox extends ConsumerWidget {
  final String label;
  final List<String> words;
  const _WordBox({
    super.key,
    required this.words,
    required this.label,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(themeServiceProvider);
    return Column(
      children: [
        renderLabel(label),
        Wrap(
          alignment: WrapAlignment.spaceEvenly,
          children: List.generate(
            words.length,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Text(
                words[index],
                style: theme.typo.subtitle1.copyWith(
                  fontSize: context.layout(32, mobile: 20),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget renderLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final List<String> passedWords;
  final List<String> correctWords;
  const _Body({
    super.key,
    required this.passedWords,
    required this.correctWords,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _WordBox(words: passedWords, label: 'PASSED WORD'),
            Divider(),
            _WordBox(words: correctWords, label: 'CORRECT WORD'),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final VoidCallback onPressed;
  const _Footer({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(label: 'Home', onPressed: onPressed);
  }
}
