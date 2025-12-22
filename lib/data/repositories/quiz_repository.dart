import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz/core/exception/quiz_exception.dart';
import 'package:quiz/data/data_sources/quiz_data_source.dart';
import 'package:quiz/data/models/pagination_params.dart';
import 'package:quiz/data/models/pagination_state.dart';
import 'package:quiz/data/models/quiz_detail_model.dart';
import 'package:quiz/quiz/model/quiz_model.dart';

final quizRepositorProvider = Provider((ref) {
  final quizDataSource = ref.read(quizDataSourceProvider);
  return QuizRepository(quizDataSource);
});

class QuizRepository {
  final QuizDataSource quizDataSource;

  QuizRepository(this.quizDataSource);

  Future<PaginationSuccess<QuizModel>> getQuiz() async {
    try {
      final resp = await quizDataSource.fetchQuiz();
      final items = resp.map((e) => QuizModel.fromJson(e)).toList();
      return PaginationSuccess(items: items);
    } catch (e) {
      throw QuizException();
    }
  }

  Future<PaginationSuccess<QuizDetailModel>> getQuizDetails({
    required int qid,
    required int take,
    required int? level,
  }) async {
    try {
      final params = PaginationParams(
        qid: qid,
        take: take,
        level: level,
      );
      final resp = await quizDataSource.fetchQuizDetails(params);
      final items = resp
          .map((e) => QuizDetailModel.fromJson(e))
          .toList();
      return PaginationSuccess(items: items);
    } catch (e) {
      throw QuizItemException();
    }
  }
}
