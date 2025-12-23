import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quiz/ui/ad/banner_ad_provider.dart';
import 'package:quiz/core/theme/theme_provider.dart';
import 'package:quiz/data/models/pagination_state.dart';
import 'package:quiz/data/models/quiz_model.dart';
import 'package:quiz/ui/common/layout/default_layout.dart';
import 'package:quiz/ui/quiz/base/quiz_view_model.dart';
import 'package:quiz/ui/quiz/base/widgets/quiz_card.dart';
import 'package:quiz/ui/wishlist/wishlist_view_model.dart';

class WishlistScreen extends ConsumerWidget {
  static String routeName = 'wishlist';

  final List<QuizModel> items;
  const WishlistScreen(this.items);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannerAd = ref.watch(bannerAdProvider);
    final theme = ref.read(themeServiceProvider);
    final wishlist = ref.watch(wishlistViewModelProvider);

    final pList = items
        .where((model) => wishlist.contains(model.id))
        .toList();
    return DefaultLayout(
      backgroundColor: Colors.white,

      /// Banner Ad
      bottomNavigationBar: SizedBox(
        height: 100,
        child: bannerAd == null
            ? null
            : AdWidget(key: ValueKey('wishlist_key'), ad: bannerAd),
      ),

      /// Wishlist
      child: Column(
        children: [
          _AppBar(),
          if (wishlist.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  '위시리스트가 비어있습니다.',
                  style: theme.typo.subtitle1.copyWith(
                    color: theme.color.secondary,
                  ),
                ),
              ),
            ),
          if (wishlist.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: wishlist.length,
                itemBuilder: (context, index) {
                  final model = pList[index];
                  return GestureDetector(
                    onTap: () {},
                    child: QuizCard.fromModel(
                      model: model,
                      isLiked: true,
                      onLikePressed: () => ref
                          .read(wishlistViewModelProvider.notifier)
                          .toggleLike(model),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _AppBar extends ConsumerWidget {
  const _AppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(themeServiceProvider);
    return AppBar(
      backgroundColor: theme.color.onSecondary,
      foregroundColor: theme.color.secondary,
      centerTitle: false,
      titleSpacing: 0,
      title: Text(
        '위시리스트',
        style: theme.typo.headline5.copyWith(
          color: theme.color.secondary,
        ),
      ),
    );
  }
}
