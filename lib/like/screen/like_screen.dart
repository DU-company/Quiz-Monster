import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz/common/screen/default_layout.dart';
import 'package:quiz/common/theme/layout.dart';
import 'package:quiz/home/component/quiz_card.dart';
import 'package:quiz/like/provider/like_provider.dart';

import '../../common/component/custom_bottom_sheet.dart';
import '../../common/provider/selected_quiz_provider.dart';
import '../../quiz/model/quiz_model.dart';
import '../../setting/screen/level_screen.dart';
import '../../setting/screen/pass_screen.dart';

class LikeScreen extends ConsumerWidget {
  static String routeName = 'like';
  const LikeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likeList = ref.watch(likeProvider);

    return DefaultLayout(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: kToolbarHeight),
          _AppBar(),
          if (likeList.isEmpty)
            Expanded(child: Center(child: Text('찜 한 게임이 없습니다!'))),
          if (likeList.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: likeList.length,
                itemBuilder: (context, index) {
                  final model = likeList[index];
                  return GestureDetector(
                    onTap: () => onCardPressed(context, ref, model),
                    child: QuizCard.fromModel(
                      model: model,
                      isLiked: true,
                      onLikePressed: () =>
                          ref.read(likeProvider.notifier).onLikePressed(model),
                    ),
                  );
                },
              ),
            )
        ],
      ),
    );
  }

  void onCardPressed(BuildContext context, WidgetRef ref, QuizModel model) {
    showModalBottomSheet(
      backgroundColor: Color(0xFFEFEFEF),
      context: context,
      enableDrag: true,
      isScrollControlled: true,
      builder: (context) {
        return CustomBottomSheet(
          title: model.title,
          desc: model.desc,
          height: 300,
          label: '닫기',
          redLabel: '시작하기',
          onPressed: () {
            context.pop();
          },
          onRedPressed: () {
            context.pop();
            if (model.pass) {
              context.pushNamed(PassScreen.routeName);
            } else {
              context.pushNamed(LevelScreen.routeName);
            }

            ref.read(selectedQuizProvider.notifier).state = model;
          },
        );
      },
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.arrow_back_ios,
            ),
          ),
          Text(
            '찜 목록',
            style: TextStyle(
              fontSize: context.layout(22, mobile: 18),
            ),
          ),
        ],
      ),
    );
  }
}
