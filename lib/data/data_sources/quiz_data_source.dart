import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz/core/service/supabase_provider.dart';
import 'package:quiz/data/models/pagination_params.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final quizDataSourceProvider = Provider((ref) {
  final supabase = ref.read(supabaseProvider);
  return QuizDataSource(supabase);
});

class QuizDataSource {
  final SupabaseClient supabase;

  QuizDataSource(this.supabase);

  Future<List<Map<String, dynamic>>> fetchQuiz() async {
    final resp = await supabase.from('quiz').select();
    return resp;
  }

  Future<List<Map<String, dynamic>>> fetchQuizDetails(
    PaginationParams params,
  ) async {
    if (params.level == null) {
      /// 난이도 상관 없이 랜덤
      return supabase.rpc(
        'random_pagination',
        params: params.toJson(),
      );
    } else {
      /// 난이도가 존재한다. ( 1 2 3 )
      return supabase.rpc(
        'random_pagination_with_level',
        params: params.toJson(),
      );
    }
  }
}
