import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz/data/models/pagination_state.dart';
import 'package:quiz/data/repositories/quiz_repository.dart';

final quizViewModelProvider = NotifierProvider(() => QuizViewModel());

class QuizViewModel extends Notifier<PaginationState> {
  QuizRepository get repository => ref.read(quizRepositorProvider);

  @override
  PaginationState build() {
    getQuizList();
    return PaginationLoading();
  }

  Future<void> getQuizList() async {
    try {
      state = PaginationLoading();
      final resp = await repository.getQuiz();
      state = resp;
    } catch (e) {
      state = PaginationError(message: e.toString());
    }
  }
}
