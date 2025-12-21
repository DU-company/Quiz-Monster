import 'package:flutter_riverpod/legacy.dart';
import 'package:quiz/common/model/pagination_model.dart';
import 'package:quiz/quiz/repository/quiz_repository.dart';
import 'package:quiz/setting/screen/level_screen.dart';

import '../../setting/provider/level_provider.dart';

final quizItemProvider = StateNotifierProvider.family.autoDispose<QuizItemStateNotifier,
    QuizPaginationBase, String>(
  (ref, id) {
    final repository = ref.watch(quizRepositoryProvider);
    final level = ref.watch(levelProvider);
    return QuizItemStateNotifier(
      id: id,
      level: level,
      repository: repository,
    );
  },
);

class QuizItemStateNotifier extends StateNotifier<QuizPaginationBase> {
  final String id;
  final int? level;
  final QuizRepository repository;

  QuizItemStateNotifier({
    required this.id,
    required this.level,
    required this.repository,
  }) : super(QuizPaginationLoading()) {
    getQuizItems();
  }

  Future<void> getQuizItems() async {
    state = QuizPaginationLoading();
    try {
      final resp = await repository.getQuizItems(quizId: id, level: level);
      final newModels = resp.models;
      newModels.shuffle();

      state = resp.copyWith(models: newModels);
    } catch (e) {
      print(e);
      state = QuizPaginationError(message: '게임을 불러올 수 없어요!\n네트워크 연결을 확인해주세요!');
    }
  }
}
