import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:quiz/quiz/model/quiz_model.dart';

final likeProvider = StateNotifierProvider<LikeStateNotifier, List<QuizModel>>(
  (ref) {
    // final Box<QuizModel> box = Hive.box<QuizModel>('like');
    return LikeStateNotifier();
  },
);

class LikeStateNotifier extends StateNotifier<List<QuizModel>> {
  // final Box<QuizModel> box;
  LikeStateNotifier() : super([]) {
    getLikeList();
  }

  Future<void> onLikePressed(QuizModel model) async {
    final box = await Hive.openBox<QuizModel>('like');

    final likeList = box.get(model.id);
    if (likeList == null) {
      await box.put(model.id, model);
      state = [...state, model];
    } else {
      await box.delete(model.id);
      state = state.where((e) => e.id != model.id).toList();
    }
  }

  void getLikeList() async{
    final box = await Hive.openBox<QuizModel>('like');

    final likeList = box.values.toList();
    state = likeList;
  }
}
