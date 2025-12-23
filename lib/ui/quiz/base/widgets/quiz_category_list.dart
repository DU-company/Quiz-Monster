import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz/core/const/data.dart';
import 'package:quiz/core/theme/app_theme.dart';
import 'package:quiz/core/theme/theme_provider.dart';

class QuizCategoryList extends ConsumerWidget {
  final void Function(int) onPressed;
  final int currentIndex;
  const QuizCategoryList({
    super.key,
    required this.onPressed,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(themeServiceProvider);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: CATEGORIES.length,
            itemBuilder: (context, index) {
              if (index == CATEGORIES.length) {
                return renderCategoryButton(index, '기타 게임', theme);
              }
              return renderCategoryButton(
                index,
                CATEGORIES[index],
                theme,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget renderCategoryButton(
    int index,
    String label,
    AppTheme theme,
  ) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: theme.color.onSecondary,
        backgroundColor: Colors.transparent,
      ),
      onPressed: () => onPressed(index),
      child: Text(
        label,
        style: theme.typo.subtitle2.copyWith(
          color: index == currentIndex
              ? theme.color.secondary
              : theme.color.subtext,
          fontWeight: index == currentIndex
              ? theme.typo.semiBold
              : theme.typo.regular,
        ),
      ),
    );
  }
}
