import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_monster/core/provider/selected_quiz_provider.dart';
import 'package:quiz_monster/data/repositories/quiz_repository.dart';
import 'package:quiz_monster/ui/quiz/detail/widgets/quiz_detail_state.dart';
import 'package:quiz_monster/ui/settings/level/level_provider.dart';

final quizDetailViewModelProvider = NotifierProvider.family
    .autoDispose((int qid) => QuizDetailViewModel(qid));

class QuizDetailViewModel extends Notifier<QuizDetailState> {
  final int qid;
  QuizDetailViewModel(this.qid);

  QuizRepository get repository => ref.read(quizRepositorProvider);
  @override
  QuizDetailState build() {
    getQuizDetails();
    return QuizDetailLoading();
  }

  Future<void> getQuizDetails() async {
    try {
      state = QuizDetailLoading();

      final quiz = ref.read(selectedQuizProvider)!;
      final level = ref.read(levelProvider);
      final resp = await repository.getQuizDetails(
        quiz: quiz,
        qid: qid,
        take: 30,
        level: level,
      );
      state = resp;
    } catch (e) {
      state = QuizDetailError(e.toString());
    }
  }
}
