import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz/quiz/repository/quiz_repository.dart';

import '../../common/model/pagination_model.dart';
import '../model/quiz_model.dart';

final quizProvider = StateNotifierProvider<QuizStateNotifier, QuizPaginationBase>(
  (ref) {
    final repository = ref.watch(quizRepositoryProvider);
    return QuizStateNotifier(repository: repository);
  },
);

class QuizStateNotifier extends StateNotifier<QuizPaginationBase> {
  final QuizRepository repository;

  QuizStateNotifier({required this.repository})
      : super(QuizPaginationLoading()) {
    getQuiz();
  }

  Future<void> getQuiz() async {

    state = QuizPaginationLoading();
    await Future.delayed(Duration(seconds: 2));
    try {
      final resp = await repository.getQuiz();
      state = resp;
    } catch (e) {
      print(e);
      state =
          QuizPaginationError(message: '게임 목록을 불러올 수 없습니다.\n네트워크 연결을 확인해주세요!');
    }
  }
}
