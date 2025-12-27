import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz/core/provider/selected_quiz_provider.dart';
import 'package:quiz/data/models/quiz_model.dart';
import 'package:quiz/ui/settings/player/player_screen.dart';
import 'package:quiz/ui/settings/level/level_screen.dart';
import 'package:quiz/ui/settings/pass/pass_screen.dart';
import 'package:quiz/ui/settings/time/time_count_screen.dart';
import 'package:quiz/ui/common/widgets/dialog/base_confirm_dialog.dart';

class StartQuizDialog extends ConsumerWidget {
  final QuizModel model;

  const StartQuizDialog({super.key, required this.model});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseConfirmDialog(
      title: model.title,
      content: model.desc,
      confirmLabel: '시작하기',
      onTapConfirm: () => onTapStart(context, ref),
      cancelLabel: '닫기',
    );
  }

  void onTapStart(BuildContext context, WidgetRef ref) {
    context.pop();
    ref.read(selectedQuizProvider.notifier).state = model;

    if (model.title == '라이어 게임') {
      context.pushNamed(PlayerScreen.routeName);
      return;
    }
    if (model.title == '반응속도 테스트') {
      context.pushNamed(TimeCountScreen.routeName);
      return;
    }
    if (model.hasPass) {
      context.pushNamed(PassScreen.routeName);
      return;
    } else {
      context.pushNamed(LevelScreen.routeName);
      return;
    }
  }
}
