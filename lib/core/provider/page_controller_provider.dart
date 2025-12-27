import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz/ui/quiz/detail/widgets/quiz_detail_success_view.dart';

final pageControllerProvider = NotifierProvider.autoDispose(
  () => PageControllerNotifier(),
);

class PageControllerNotifier extends Notifier<PageController> {
  @override
  PageController build() {
    final currentIndex = ref.read(currentIndexProvider);
    state = PageController(initialPage: currentIndex);
    return state;
  }

  void nextPage() {
    state.nextPage(
      duration: Duration(milliseconds: 1),
      curve: Curves.linear,
    );
  }

  void previousPage() {
    state.previousPage(
      duration: Duration(milliseconds: 1),
      curve: Curves.linear,
    );
  }
}
