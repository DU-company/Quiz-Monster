import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_monster/core/theme/theme_provider.dart';
import 'package:quiz_monster/data/models/quiz_detail_model.dart';
import 'package:quiz_monster/ui/common/layout/quiz_detail_layout.dart';
import 'package:quiz_monster/ui/common/screens/home_screen.dart';
import 'package:quiz_monster/ui/common/widgets/primary_button.dart';
import 'package:quiz_monster/ui/common/layout/default_layout.dart';
import 'package:quiz_monster/ui/quiz/detail/widgets/exit_dialog.dart';
import 'package:quiz_monster/ui/quiz/etc/liar/liar_view_model.dart';
import 'package:quiz_monster/ui/quiz/etc/liar/widgets/liar_app_bar.dart';
import 'package:quiz_monster/ui/quiz/etc/liar/widgets/liar_body.dart';
import 'package:quiz_monster/ui/quiz/etc/liar/widgets/liar_footer.dart';
import 'package:quiz_monster/ui/quiz/etc/liar/widgets/show_answer_dialog.dart';
import 'package:quiz_monster/ui/settings/player/set_player_view_model.dart';
import 'package:quiz_monster/core/provider/page_controller_provider.dart';
import 'package:quiz_monster/ui/quiz/detail/widgets/quiz_detail_success_view.dart';

class LiarGameScreen extends ConsumerWidget {
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
              LiarAppBar(
                label: isLastPage ? '' : 'PLAYER ${currentIndex + 1}',
                onBackPressed: () => onBackPressed(context, ref),
              ),
              QuizDetailLayout(
                body: Column(
                  children: [
                    LiarBody(
                      pageController: pageController,
                      playerCount: playerCount,
                      showAnswer: showAnswer,
                      liarIndex: liarIndex,
                      items: items,
                      isLastPage: isLastPage,
                      onTapButton: isLastPage
                          ? () => showAnswerDialog(context, ref)
                          : () => onTapAnswer(ref),
                    ),
                  ],
                ),
                footer: LiarFooter(
                  isBeforeLastPage: isBeforeLastPage,
                  onNext: (isLastPage || !showAnswer)
                      ? null
                      : () => onNext(ref, pageController),
                ),
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
      builder: (context) => ShowAnswerDialog(
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
