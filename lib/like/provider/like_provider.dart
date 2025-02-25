import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:quiz/quiz/model/quiz_model.dart';

final likeProvider = StateNotifierProvider<LikeStateNotifier, List<int>>(
  (ref) {
    return LikeStateNotifier();
  },
);

class LikeStateNotifier extends StateNotifier<List<int>> {
  LikeStateNotifier() : super([]) {
    getLikeList();
  }

  Future<void> onLikePressed(QuizModel model) async {
    final box = await Hive.openBox<int>('likes');
    final selectedId = model.id;
    final likedModel = box.get(selectedId);

    if (likedModel == null) {
      await box.put(selectedId, selectedId);
      state = [...state, selectedId];
    } else {
      await box.delete(selectedId);
      state = state.where((id) => id != selectedId).toList();
    }

    // final box = await Hive.openBox<QuizModel>('like');
    //
    // final likeList = box.get(model.id);
    // if (likeList == null) {
    //   await box.put(model.id, model);
    //   state = [...state, model];
    // } else {
    //   await box.delete(model.id);
    //   state = state.where((e) => e.id != model.id).toList();
    // }
  }

  void getLikeList() async {
    final box = await Hive.openBox<int>('likes');
    final likeList = box.values.toList();
    state = likeList;
    // final box = await Hive.openBox<QuizModel>('like');
    //
    // final likeList = box.values.toList();
    // state = likeList;
  }
}
