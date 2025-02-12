import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz/common/component/primary_button.dart';
import 'package:quiz/common/data/colors.dart';
import 'package:quiz/common/provider/selected_quiz_provider.dart';
import 'package:quiz/common/screen/default_layout.dart';
import 'package:quiz/common/theme/layout.dart';
import 'package:quiz/setting/screen/responsive_screen.dart';

import '../../time/screen/time_screen.dart';
import '../provider/level_provider.dart';


class LevelScreen extends ConsumerWidget {
  static String routeName = 'level';

  const LevelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedQuiz = ref.watch(selectedQuizProvider);
    final level = ref.watch(levelProvider);
    return ResponsiveSettingScreen(
      label: '난이도를\n설정해 주세요',
      body: _LevelButton(
        level: level,
        onLevelChanged: (index) {
          ref.read(levelProvider.notifier).state = index + 1;
        },
        onOverallPressed: () => onOverallPressed(context, ref),
      ),
      footer: _NextButton(
        level: level,
        onPressed: () => onNextPressed(context),
      ),
    );
  }

  void onOverallPressed(BuildContext context, WidgetRef ref) {
    ref.read(levelProvider.notifier).state = null;
    context.pushNamed(
      TimeScreen.routeName,
    );
  }

  void onNextPressed(BuildContext context) {
    context.pushNamed(
      TimeScreen.routeName,
    );
  }
}

class _LevelButton extends StatelessWidget {
  final int? level;
  final void Function(int) onLevelChanged;
  final VoidCallback onOverallPressed;
  const _LevelButton({
    super.key,
    required this.level,
    required this.onLevelChanged,
    required this.onOverallPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.layout(300, mobile: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              3,
              (index) {
                final bool isEmptyStar = (level == null || index + 1 > level!);
                return Material(
                  color: Colors.white,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () => onLevelChanged(index),
                    child: Stack(
                      children: [
                        Icon(
                          Icons.star_border,
                          size: 56,
                          color: Colors.black54, // 테두리 색상
                        ),
                        Icon(
                          Icons.star,
                          size: 56,
                          color: isEmptyStar
                              ? Colors.transparent
                              : Colors.orange, // 내부 색상
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          TextButton(
            onPressed: onOverallPressed,
            style: TextButton.styleFrom(foregroundColor: MAIN_COLOR),
            child: Text(
              '난이도 상관없이 플레이',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  final int? level;
  final VoidCallback onPressed;
  const _NextButton({
    super.key,
    required this.level,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      label: '다음',
      onPressed: level == null ? null : onPressed,
    );
  }
}
