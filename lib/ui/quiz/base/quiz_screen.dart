import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz/data/models/pagination_state.dart';
import 'package:quiz/data/models/quiz_model.dart';
import 'package:quiz/ui/common/widgets/error_message_widget.dart';
import 'package:quiz/ui/common/widgets/loading_widget.dart';
import 'package:quiz/ui/quiz/base/quiz_view_model.dart';
import 'package:quiz/ui/quiz/base/widgets/quiz_success_view.dart';

class QuizScreen extends ConsumerWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizViewModelProvider);
    return _body(quizState, ref);
  }

  Widget _body(PaginationState state, WidgetRef ref) {
    if (state is PaginationLoading) {
      return LoadingWidget();
    }
    if (state is PaginationError) {
      return ErrorMessageWidget(
        message: state.message,
        onTap: () =>
            ref.read(quizViewModelProvider.notifier).getQuizList(),
        label: '다시시도',
      );
    }

    state as PaginationSuccess<QuizModel>;
    return QuizSuccessView(state.items);
  }
}
