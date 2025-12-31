import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_monster/ui/quiz/base/quiz_screen.dart';
import 'package:quiz_monster/ui/quiz/etc/liar/liar_screen.dart';
import 'package:quiz_monster/ui/quiz/detail/view_model/quiz_detail_state.dart';
import 'package:quiz_monster/ui/quiz/detail/widgets/quiz_detail_success_view.dart';
import 'package:quiz_monster/ui/common/layout/default_layout.dart';
import 'package:quiz_monster/ui/common/widgets/error_message_widget.dart';
import 'package:quiz_monster/ui/common/widgets/loading_widget.dart';
import 'package:quiz_monster/ui/quiz/detail/view_model/quiz_detail_view_model.dart';

class QuizDetailScreen extends ConsumerWidget {
  static String get routeName => 'quiz-detail';
  final int qid;
  const QuizDetailScreen(this.qid, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(quizDetailViewModelProvider(qid));
    return DefaultLayout(
      needWillPopScope: true,
      needPadding: true,
      child: _body(detailState, context),
    );
  }

  Widget _body(QuizDetailState state, BuildContext context) {
    if (state is QuizDetailLoading) {
      return LoadingWidget();
    }
    if (state is QuizDetailError) {
      return ErrorMessageWidget(
        message: state.message,
        onTap: () => context.goNamed(QuizScreen.routeName),
        label: '홈으로',
      );
    }
    state as QuizDetailSuccess;

    if (state.quiz.title.contains('라이어 게임')) {
      // 라이어 게임은 앱바가 필요하지 않고, 다른 게임들과 화면 분리가 필요
      return LiarGameScreen(state.items);
    }
    return QuizDetailSuccessView(state.items);
  }
}
