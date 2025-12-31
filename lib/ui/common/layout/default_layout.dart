import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_monster/core/theme/constrained_screen.dart';
import 'package:quiz_monster/core/theme/theme_provider.dart';
import 'package:quiz_monster/core/utils/data_utils.dart';

final willPopScopeTimeProvider = StateProvider<DateTime?>(
  (ref) => null,
);

class DefaultLayout extends ConsumerWidget {
  final Widget child;
  final Color? backgroundColor;
  final bool needPadding;
  final bool needSafeArea;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final bool needWillPopScope;
  const DefaultLayout({
    super.key,
    required this.child,
    this.backgroundColor,
    this.appBar,
    this.bottomNavigationBar,
    this.needPadding = true,
    this.needWillPopScope = false,
    this.needSafeArea = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentBackPressTime = ref.watch(willPopScopeTimeProvider);
    final theme = ref.read(themeServiceProvider);

    return WillPopScope(
      onWillPop: needWillPopScope
          ? () async =>
                onWillPop(
                  currentBackPressTime,
                  ref,
                ) //뒤로가기 두번 눌러야 앱 종료,
          : null, // 일반 화면은 그냥 뒤로가기
      child: Scaffold(
        appBar: appBar,
        backgroundColor: backgroundColor ?? theme.color.surface,
        body: ConstrainedScreen(
          child: SafeArea(
            bottom: needSafeArea,
            top: needSafeArea,
            child: Padding(
              padding: needPadding
                  ? EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: Platform.isIOS ? 0 : 8,
                    )
                  : EdgeInsets.zero,
              child: child,
            ),
          ),
        ),
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }

  Future<bool> onWillPop(
    DateTime? currentBackPressTime,
    WidgetRef ref,
  ) {
    DateTime now = DateTime.now();

    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) >
            const Duration(seconds: 2)) {
      ref.read(willPopScopeTimeProvider.notifier).state = now;
      const msg = "'뒤로가기'를 두 번 누르면 앱이 종료됩니다";

      Fluttertoast.showToast(msg: msg, backgroundColor: Colors.grey);
      return Future.value(false);
    }

    return Future.value(true);
  }
}
