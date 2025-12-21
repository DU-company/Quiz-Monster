import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz/common/data/colors.dart';
import 'package:quiz/quiz/screen/pass_quiz_screen.dart';
import 'package:quiz/setting/screen/responsive_screen.dart';
import '../../common/component/primary_button.dart';
import '../../time/screen/time_screen.dart';
import '../provider/level_provider.dart';
import '../provider/pass_provider.dart';

class PassScreen extends ConsumerWidget {
  static String routeName = 'pass';
  const PassScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pass = ref.watch(passProvider);

    return ResponsiveSettingScreen(
      label: '패스 횟수를 선택해주세요\n(0~9회 선택 가능)',
      body: _PassKeyboard(
        pass: pass,
        onPressed: (index) => index == pass ? {} : onPassPressed(index, ref),
        noPassPressed: (index) {
          onPassPressed(index, ref);
          onNextPressed(context, ref);
        },
      ),
      footer: _NextButton(
        pass: pass,
        onPressed: () {
          ref.read(levelProvider.notifier).update((state) => state = null);
          onNextPressed(context, ref);
        },
      ),
    );
  }

  void onPassPressed(int index, WidgetRef ref) {
    ref.read(passProvider.notifier).state = index;
  }

  void onNextPressed(BuildContext context, WidgetRef ref) {
    context.pushNamed(TimeScreen.routeName);

    /// 결과 화면을 위한 pass/correct 상태값 초기화
    ref.read(passedWordProvider.notifier).state = [];
    ref.read(correctWordProvider.notifier).state = [];
  }
}

class _PassKeyboard extends StatelessWidget {
  final int pass;
  final void Function(int) onPressed;
  final void Function(int) noPassPressed;
  const _PassKeyboard({
    super.key,
    required this.pass,
    required this.onPressed,
    required this.noPassPressed,
  });

  @override
  Widget build(BuildContext context) {
    final ts = TextStyle(
      color: Colors.black,
      fontSize: 32,
      fontFamily: 'Roboto',
    );
    final buttons = [1, 2, 3, 4, 5, 6, 7, 8, 9];

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 32, horizontal: 8),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              Text(
                'PASS : $pass 회',
                textAlign: TextAlign.center,
                style: ts.copyWith(fontSize: 24, color: MAIN_COLOR),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: buttons.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 3,
                ),
                itemBuilder: (context, index) {
                  return Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () => onPressed(index + 1),
                      child: Center(
                        child: Text(
                          buttons[index].toString(),
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => noPassPressed(0),
                style: TextButton.styleFrom(foregroundColor: MAIN_COLOR),
                child: Text(
                  '패스 없이 게임하기',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "긴박한 순간!\n팀원과 상의하여 광고를 시청하면\n패스를 한 번 추가할 수 있습니다.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _NextButton extends StatelessWidget {
  final int? pass;
  final VoidCallback onPressed;
  const _NextButton({
    super.key,
    required this.pass,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      label: '다음',
      onPressed: pass == null ? null : onPressed,
    );
  }
}
