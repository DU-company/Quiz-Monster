import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:quiz/quiz/screen/default_quiz_screen.dart';

class PageControllerNotifier extends StateNotifier<PageController> {
  final int currentIndex;
  PageControllerNotifier({
    required this.currentIndex,
  }) : super(PageController(initialPage: currentIndex));

  void nextPage() {
    state.nextPage(
      duration: Duration(microseconds: 1),
      curve: Curves.linear,
    );
  }

  void previousPage() {
    state.previousPage(
      duration: Duration(microseconds: 1),
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    state.dispose(); // 컨트롤러 메모리 해제
    super.dispose();
  }
}

final pageControllerProvider =
    StateNotifierProvider<PageControllerNotifier, PageController>((ref) {
  final currentIndex = ref.watch(currentIndexProvider);
  return PageControllerNotifier(
    currentIndex: currentIndex,
  );
});
