import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_monster/ui/common/widgets/primary_button.dart';
import 'package:quiz_monster/core/provider/selected_quiz_provider.dart';
import 'package:quiz_monster/ui/common/layout/setting_layout.dart';
import 'package:quiz_monster/ui/settings/level/level_button.dart';

import '../time/time_screen.dart';
import 'level_provider.dart';

class LevelScreen extends ConsumerWidget {
  static String routeName = 'level';

  const LevelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final level = ref.watch(levelProvider);
    return SettingLayout(
      label: '난이도를\n설정해 주세요',
      body: LevelButton(
        level: level,
        onLevelChanged: (index) {
          ref.read(levelProvider.notifier).state = index + 1;
        },
        onTapNoLevel: () => onOverallPressed(context, ref),
      ),
      footer: PrimaryButton(
        label: 'NEXT',
        onPressed: level == null
            ? null
            : () => onNextPressed(context),
      ),
    );
  }

  void onOverallPressed(BuildContext context, WidgetRef ref) {
    ref.read(levelProvider.notifier).state = null;
    context.pushNamed(TimeScreen.routeName);
  }

  void onNextPressed(BuildContext context) {
    context.pushNamed(TimeScreen.routeName);
  }
}
