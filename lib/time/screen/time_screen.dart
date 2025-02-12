import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz/common/component/primary_button.dart';
import 'package:quiz/common/data/colors.dart';
import 'package:quiz/common/provider/selected_quiz_provider.dart';
import 'package:quiz/common/screen/default_layout.dart';
import 'package:quiz/common/theme/layout.dart';
import 'package:quiz/common/utils/data_utils.dart';
import 'package:quiz/home/screen/home_screen.dart';
import 'package:quiz/quiz/screen/default_quiz_screen.dart';
import 'package:quiz/setting/screen/responsive_screen.dart';
import 'package:quiz/time/provider/time_provider.dart';
import 'package:quiz/time/screen/time_count_screen.dart';

class TimeScreen extends ConsumerWidget {
  static String routeName = 'time';

  const TimeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedQuiz = ref.watch(selectedQuizProvider);
    Duration newDuration =
        selectedQuiz!.pass ? Duration(minutes: 3) : Duration(seconds: 5);

    return ResponsiveSettingScreen(
      label: selectedQuiz.pass ? '총 게임 시간을\n설정해 주세요' : '1인 제한 시간을\n설정해 주세요',
      body: _Body(
        newDuration: newDuration,
        onTimerDurationChanged: (duration) {
          newDuration = duration;
        },
      ),
      footer: _Footer(
        onPressed: () async {
          if (newDuration.inSeconds < 3) {
            DataUtils.showToast(msg: '최소 제한 시간은 3초 입니다.');
          } else {
            ref.read(timeProvider.notifier).state = newDuration;
            context.goNamed(
              TimeCountScreen.routeName,
            );
          }
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final void Function(Duration) onTimerDurationChanged;
  final Duration newDuration;
  const _Body({
    super.key,
    required this.newDuration,
    required this.onTimerDurationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.layout(300, mobile: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
      ),
      child: CupertinoTimerPicker(
        mode: CupertinoTimerPickerMode.ms,
        initialTimerDuration: newDuration,
        onTimerDurationChanged: onTimerDurationChanged,
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final VoidCallback onPressed;
  const _Footer({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      label: 'START',
      onPressed: onPressed,
    );
  }
}
