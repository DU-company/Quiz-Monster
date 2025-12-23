import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:quiz/core/const/data.dart';
import 'package:quiz/data/models/quiz_model.dart';
import 'package:quiz/ui/quiz/base/widgets/quiz_app_bar.dart';
import 'package:quiz/ui/quiz/base/widgets/quiz_card.dart';
import 'package:quiz/ui/common/layout/default_layout.dart';
import 'package:quiz/ui/quiz/base/widgets/quiz_category_list.dart';
import 'package:quiz/ui/quiz/base/widgets/start_quiz_dialog.dart';
import 'package:quiz/ui/wishlist/wishlist_view_model.dart';

final _indexProvider = StateProvider((ref) => 0);

class QuizSuccessView extends ConsumerWidget {
  final List<QuizModel> items;
  const QuizSuccessView(this.items, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlist = ref.watch(wishlistViewModelProvider);
    final currentIndex = ref.watch(_indexProvider);

    /// 현재 카테고리에 해당하는 QuizModel로 parsing
    final pList = currentIndex + 1 < CATEGORIES.length
        ? items
              .where(
                (model) =>
                    model.title.contains(CATEGORIES[currentIndex]),
              )
              .toList()
        : items.where((e) => e.isEtc == true).toList();
    return DefaultLayout(
      backgroundColor: Colors.white,
      child: CustomScrollView(
        slivers: [
          QuizAppBar(items),
          QuizCategoryList(
            onPressed: (index) {
              ref.read(_indexProvider.notifier).state = index;
            },
            currentIndex: currentIndex,
          ),
          SliverList.builder(
            itemCount: pList.length,
            itemBuilder: (context, index) {
              final model = pList[index];
              final isLiked = wishlist.any((id) => id == model.id);

              return GestureDetector(
                onTap: () => onTapCard(context, ref, model),
                child: QuizCard.fromModel(
                  isLiked: isLiked,
                  onLikePressed: () => ref
                      .read(wishlistViewModelProvider.notifier)
                      .toggleLike(model),
                  model: model,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void onTapCard(
    BuildContext context,
    WidgetRef ref,
    QuizModel model,
  ) {
    showDialog(
      context: context,
      builder: (context) => StartQuizDialog(model: model),
    );
  }
}
