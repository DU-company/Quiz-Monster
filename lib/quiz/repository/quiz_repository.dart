import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:quiz/core/service/supabase_provider.dart';
import 'package:quiz/quiz/model/quiz_item_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/models/pagination_state.dart';
import '../model/quiz_model.dart';

final quizRepositoryProvider = Provider(
  (ref) {
    final supabase = ref.watch(supabaseProvider);
    return QuizRepository(supabase: supabase);
  },
);

class QuizRepository {
  final SupabaseClient supabase;

  QuizRepository({
    required this.supabase,
  });

  Future<PaginationSuccess<QuizModel>> getQuiz() async {
    final resp = await supabase.from('quiz').select();
    final quizModels = resp.map((quiz) => QuizModel.fromJson(quiz)).toList();
    return PaginationSuccess(models: quizModels);
  }

  Future<PaginationSuccess<QuizItemModel>> getQuizItems({
    required String quizId,
    required int? level,
  }) async {
    // print('level : $level');
    List<Map<String, dynamic>> resp;
    if (level == null) {
      /// 난이도 상관 없이 다 가져오기
      resp = await supabase.rpc('random', params: {
        'qid_value': quizId,
        'limit_value': 30,
      });

    } else {
      /// 난이도가 존재한다. 1 2 3
      resp = await supabase.rpc('random_with_level', params: {
        'qid_value': quizId,
        'limit_value': 30,
        'level_value': level,
      });

    }
    final quizItemModels =
        resp.map((item) => QuizItemModel.fromJson(item)).toList();
    return PaginationSuccess(models: quizItemModels);
  }
}
