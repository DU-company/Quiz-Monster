import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz/common/component/pagination_screen.dart';
import 'package:quiz/common/data/colors.dart';
import 'package:quiz/common/data/data.dart';
import 'package:quiz/common/provider/selected_quiz_provider.dart';
import 'package:quiz/common/screen/default_layout.dart';
import 'package:quiz/common/theme/layout.dart';
import 'package:quiz/home/component/quiz_card.dart';
import 'package:quiz/like/provider/like_provider.dart';
import 'package:quiz/like/screen/like_screen.dart';
import 'package:quiz/quiz/model/quiz_model.dart';
import 'package:quiz/quiz/provider/quiz_provider.dart';
import '../../common/component/custom_bottom_sheet.dart';
import '../../common/model/pagination_model.dart';
import '../../setting/screen/level_screen.dart';
import '../../setting/screen/pass_screen.dart';
import '../../test/test_screen.dart';

final _indexProvider = StateProvider((ref) => 0);

class HomeScreen extends ConsumerWidget {
  static String routeName = 'home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(quizProvider);
    final currentIndex = ref.watch(_indexProvider);
    final likeList = ref.watch(likeProvider);

    print(likeList.length);

    if (data is QuizPagination<QuizModel>) {
      /// 현재 카테고리에 해당하는 QuizModel로 parsing
      final pList = data.models
          .where((model) => model.title.contains(CATEGORIES[currentIndex]))
          .toList();
      // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
      // final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      //     MediaQuery.sizeOf(context).width.truncate());
      return DefaultLayout(
        backgroundColor: Colors.white,
        child: CustomScrollView(
          slivers: [
            _AppBar(),
            _CategoryListView(
              onPressed: (index) {
                ref.read(_indexProvider.notifier).state = index;
              },
              currentIndex: currentIndex,
            ),
            if (pList.isEmpty) _NoGameNotiBox(),
            SliverList.builder(
              itemCount: pList.length,
              itemBuilder: (context, index) {
                final model = pList[index];
                return GestureDetector(
                  onTap: () => onCardPressed(context, ref, model),
                  child: QuizCard.fromModel(
                    isLiked: likeList.where((e) => e.id == model.id).isNotEmpty,
                    onLikePressed: () =>
                        ref.read(likeProvider.notifier).onLikePressed(model),
                    model: model,
                  ),
                );
              },
            )
          ],
        ),
      );
    }

    /// Loading or Error
    return PaginationScreen(data: data);
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

/// ----------------------------------------------------------------------
class _AppBar extends StatelessWidget {
  const _AppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(height: kToolbarHeight),
            renderTop(
              onMenuPressed: () {},
              onLikePressed: () => context.pushNamed(LikeScreen.routeName),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "WHO'S DRUNK?\nLET'S PLAY!🔥",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: context.layout(56, mobile: 28),
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Image.asset(
                  'assets/img/eyes2.png',
                  width: context.layout(150, mobile: 80),
                  fit: BoxFit.cover,
                  // scale: 0.5,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget renderTop({
    required VoidCallback onMenuPressed,
    required VoidCallback onLikePressed,
  }) {
    return Row(
      children: [
        Text(
          'QUIZ MONSTER',
          style: TextStyle(
            color: MAIN_COLOR,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
          ),
        ),
        Spacer(),
        IconButton(
          onPressed: onLikePressed,
          icon: Icon(CupertinoIcons.suit_heart),
        ),
        IconButton(
          onPressed: onMenuPressed,
          icon: Icon(
            Icons.menu,
          ),
        ),
      ],
    );
  }
}

class _CategoryListView extends StatelessWidget {
  final void Function(int) onPressed;
  final int currentIndex;
  const _CategoryListView({
    super.key,
    required this.onPressed,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: CATEGORIES.length,
            itemBuilder: (context, index) {
              return TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                onPressed: () => onPressed(index),
                child: Text(
                  CATEGORIES[index],
                  style: TextStyle(
                    color:
                        index == currentIndex ? Colors.black : Colors.black45,
                    fontWeight: index == currentIndex
                        ? FontWeight.w500
                        : FontWeight.w300,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NoGameNotiBox extends StatelessWidget {
  const _NoGameNotiBox({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 64.0),
        child: Text(
          '아직 준비중인 게임입니다!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
