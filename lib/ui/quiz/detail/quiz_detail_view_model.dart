import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz/data/models/pagination_state.dart';
import 'package:quiz/data/repositories/quiz_repository.dart';
import 'package:quiz/ui/settings/level/level_provider.dart';

final quizDetailViewModelProvider = NotifierProvider.family
    .autoDispose((int qid) => QuizDetailViewModel(qid));

class QuizDetailViewModel extends Notifier<PaginationState> {
  final int qid;
  QuizDetailViewModel(this.qid);

  QuizRepository get repository => ref.read(quizRepositorProvider);
  @override
  PaginationState build() {
    getQuizDetails();
    return PaginationLoading();
  }

  Future<void> getQuizDetails() async {
    try {
      state = PaginationLoading();

      final level = ref.read(levelProvider);
      final resp = await repository.getQuizDetails(
        qid: qid,
        take: 30,
        level: level,
      );
      state = resp;
    } catch (e) {
      state = PaginationError(message: e.toString());
    }
  }
}
