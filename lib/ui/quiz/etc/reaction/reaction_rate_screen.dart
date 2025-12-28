import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quiz_monster/core/utils/data_utils.dart';
import 'package:quiz_monster/ui/ad/ad_count_provider.dart';
import 'package:quiz_monster/ui/ad/ad_finished_provider.dart';
import 'package:quiz_monster/ui/ad/interstitial_ad_view_model.dart';
import 'package:quiz_monster/ui/common/layout/quiz_detail_layout.dart';
import 'package:quiz_monster/ui/common/screens/home_screen.dart';
import 'package:quiz_monster/ui/common/widgets/dialog/base_confirm_dialog.dart';
import 'package:quiz_monster/ui/common/widgets/primary_button.dart';
import 'package:quiz_monster/ui/common/layout/default_layout.dart';
import 'package:quiz_monster/core/theme/responsive/layout.dart';
import 'package:quiz_monster/ui/quiz/detail/widgets/quiz_detail_success_view.dart';
import 'package:quiz_monster/ui/quiz/detail/widgets/exit_dialog.dart';
import 'package:quiz_monster/ui/quiz/etc/reaction/view_model/reaction_view_model.dart';
import 'package:quiz_monster/ui/quiz/etc/reaction/widgets/reaction_app_bar.dart';
import 'package:quiz_monster/ui/quiz/etc/reaction/widgets/reaction_average_box.dart';
import 'package:quiz_monster/ui/quiz/etc/reaction/widgets/reaction_circle.dart';
import 'package:quiz_monster/ui/quiz/etc/reaction/widgets/replay_dialog.dart';

class ReactionRateScreen extends ConsumerWidget {
  static String routeName = 'reaction';
  const ReactionRateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(reactionViewModelProvider.notifier);
    final reactionState = ref.watch(reactionViewModelProvider);
    ref.listen(adFinishedProvider, (p, n) async {
      if (n == true) {
        viewModel.resetScreen();
        ref.read(adFinishedProvider.notifier).onReset();
      }
    });

    // 단계 끝
    final isStepOver =
        reactionState.isGreen && reactionState.result.isNotEmpty;
    // 게임 끝
    final isGameOver =
        reactionState.currentStep == 5 &&
        reactionState.result.isNotEmpty;

    return DefaultLayout(
      needWillPopScope: true,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// AppBar
              ReactionAppBar(
                onTapBack: () => onTapBack(context),
                step: reactionState.currentStep,
              ),
              // UI 멈춤 방지
              CircularProgressIndicator(color: Colors.transparent),
              QuizDetailLayout(
                /// Body
                body: isGameOver
                    ? ReactionAverageBox(
                        testResults: reactionState.resultList,
                      )
                    : ReactionCircle(
                        onTapCircle: viewModel.onTapCircle,
                        isGreen: reactionState.isGreen,
                        label: reactionState.result,
                      ),

                /// Footer
                footer: PrimaryButton(
                  label: isGameOver ? '다시 시작' : '다음',
                  onPressed: isStepOver
                      ? isGameOver
                            ? () => shoReplayDialog(context, ref)
                            : viewModel.onTapNext
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onTapBack(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ExitDialog(
        onTapConfirm: () {
          context.pop();
          context.goNamed(HomeScreen.routeName);
        },
      ),
    );
  }

  void shoReplayDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return RecationReplayDialog(
          onTapReplay: () {
            context.pop();
            ref
                .read(interstitialAdViewModelProvider.notifier)
                .showAd();
          },
        );
      },
    );
  }
}
