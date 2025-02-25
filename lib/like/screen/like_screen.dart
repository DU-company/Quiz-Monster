import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quiz/ad/provider/banner_ad_provider.dart';
import 'package:quiz/common/model/pagination_model.dart';
import 'package:quiz/common/screen/default_layout.dart';
import 'package:quiz/common/theme/layout.dart';
import 'package:quiz/home/component/quiz_card.dart';
import 'package:quiz/like/provider/like_provider.dart';
import 'package:quiz/quiz/provider/quiz_provider.dart';

import '../../common/component/custom_bottom_sheet.dart';
import '../../common/provider/selected_quiz_provider.dart';
import '../../etc/screen/player_screen.dart';
import '../../quiz/model/quiz_model.dart';
import '../../setting/screen/level_screen.dart';
import '../../setting/screen/pass_screen.dart';

class LikeScreen extends ConsumerWidget {
  static String routeName = 'like';
  const LikeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannerAd = ref.watch(bannerAdProvider);
    final likedIdList = ref.watch(likeProvider);
    final data = ref.watch(quizProvider);

    data as QuizPagination<QuizModel>;
    final pList = data.models.where((model) => likedIdList.contains(model.id)).toList();
    return DefaultLayout(
      backgroundColor: Colors.white,
      bottomNavigationBar: bannerAd == null
          ? null
          : SizedBox(
              height: 100,
              child: AdWidget(
                key: ValueKey('like_screen_key'),
                ad: bannerAd,
              ),
            ),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: kToolbarHeight),
          _AppBar(),
          if (likedIdList.isEmpty)
            Expanded(child: Center(child: Text('찜 한 게임이 없습니다!'))),
          if (likedIdList.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: likedIdList.length,
                itemBuilder: (context, index) {
                  final model = pList[index];
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
            ),
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
          onPressed: () => context.pop(),
          onRedPressed: () {
            context.pop();

            if (model.title == '라이어 게임') {
              context.pushNamed(PlayerScreen.routeName);
              return;
            }
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
