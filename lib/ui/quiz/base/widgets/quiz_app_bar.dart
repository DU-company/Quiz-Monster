import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz/core/const/data.dart';
import 'package:quiz/core/theme/responsive/layout.dart';
import 'package:quiz/core/theme/theme_provider.dart';
import 'package:quiz/ui/wishlist/wishlist_screen.dart';

class QuizAppBar extends ConsumerWidget {
  const QuizAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              /// Top
              renderTop(
                onMenuPressed: () {},
                // onMenuPressed: () => context.pushNamed(TestScreen.routeName),
                onLikePressed: () =>
                    context.pushNamed(LikeScreen.routeName),
              ),

              /// Body
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
                  SvgPicture.asset(
                    'assets/img/eyes2.svg',
                    width: context.layout(150, mobile: 80),
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ],
          ),
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
        IconButton(onPressed: onMenuPressed, icon: Icon(Icons.menu)),
      ],
    );
  }
}
