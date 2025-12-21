import 'package:flutter_riverpod/legacy.dart';
import 'package:quiz/quiz/repository/quiz_repository.dart';

import '../../data/models/pagination_state.dart';
import '../model/quiz_model.dart';

final quizProvider = StateNotifierProvider<QuizStateNotifier, PaginationState>(
  (ref) {
    final repository = ref.watch(quizRepositoryProvider);
    return QuizStateNotifier(repository: repository);
  },
);

class QuizStateNotifier extends StateNotifier<PaginationState> {
  final QuizRepository repository;

  QuizStateNotifier({required this.repository})
      : super(PaginationLoading()) {
    getQuiz();
  }

  Future<void> getQuiz() async {

    state = PaginationLoading();
    await Future.delayed(Duration(seconds: 1));
    try {
      final resp = await repository.getQuiz();
      state = resp;
    } catch (e) {
      print(e);
      state =
          PaginationError(message: '게임 목록을 불러올 수 없습니다.\n네트워크 연결을 확인해주세요!');
    }
  }
}
