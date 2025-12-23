import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz/ad/provider/rewarded_ad_provider.dart';
import 'package:quiz/ui/quiz/pass/pass_quiz_screen.dart';
import 'package:quiz/ui/settings/time/time_screen.dart';

final passViewModelProvider = NotifierProvider(() => PassViewModel());

class PassViewModel extends Notifier<int> {
  @override
  int build() {
    state = 3;
    return state;
  }

  void onPassChanged(int number) {
    state = number;
  }

  /// 패스를 사용하지 않겠다
  void onTapNoPass(BuildContext context) {
    state = 0;
    onTapNext(context);
  }

  /// Setting 화면에서 다음 버튼을 눌렀을 때
  void onTapNext(BuildContext context) {
    context.pushNamed(TimeScreen.routeName);

    /// 결과 화면을 위한 pass/correct 상태값 초기화
    ref.read(passedWordProvider.notifier).state = [];
    ref.read(correctWordProvider.notifier).state = [];
  }

  /// 패스 사용했을 때
  void onPass(PageController pageController, String word) {
    pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.linear,
    );
    ref
        .read(passedWordProvider.notifier)
        .update((state) => state = [...state, word]);
    onPassChanged(state - 1);
  }

  /// 문제를 맞추고 다음 버튼을 눌렀을 때
  void onNextPage(PageController pageController, String word) {
    pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.linear,
    );
    ref
        .read(correctWordProvider.notifier)
        .update((state) => state = [...state, word]);
  }

  /// 광고 보고 패스 추가되는 로직
  void showAd() {
    ref
        .read(rewardedAdProvider.notifier)
        .showAd(onRewardEarned: () => onPassChanged(state + 1));
  }
}
