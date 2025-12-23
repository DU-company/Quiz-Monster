import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz/data/models/pagination_state.dart';
import 'package:quiz/data/models/quiz_detail_model.dart';
import 'package:quiz/ui/quiz/detail/widgets/quiz_detail_success_view.dart';
import 'package:quiz/ui/common/layout/default_layout.dart';
import 'package:quiz/ui/common/screens/home_screen.dart';
import 'package:quiz/ui/common/widgets/error_message_widget.dart';
import 'package:quiz/ui/common/widgets/loading_widget.dart';
import 'package:quiz/ui/quiz/detail/quiz_detail_view_model.dart';

class QuizDetailScreen extends ConsumerWidget {
  static String get routeName => 'quiz-detail';
  final int qid;
  const QuizDetailScreen(this.qid, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(quizDetailViewModelProvider(qid));
    return DefaultLayout(child: _body(detailState, context));
  }

  Widget _body(PaginationState state, BuildContext context) {
    if (state is PaginationLoading) {
      return LoadingWidget();
    }
    if (state is PaginationError) {
      return ErrorMessageWidget(
        message: state.message,
        onTap: () => context.goNamed(HomeScreen.routeName),
        label: '홈으로',
      );
    }
    state as PaginationSuccess<QuizDetailModel>;
    return QuizDetailSuccessView(state.items);
  }
}
