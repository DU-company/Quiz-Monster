import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz/core/const/data.dart';
import 'package:quiz/core/theme/constrained_screen.dart';
import 'package:quiz/core/utils/data_utils.dart';

final willPopScopeTimeProvider = StateProvider<DateTime?>((ref) => null);

class DefaultLayout extends ConsumerWidget {
  final Widget child;
  final Color? backgroundColor;
  final String? title;
  final Widget? bottomNavigationBar;
  final bool needWillPopScope;
  const DefaultLayout({
    super.key,
    required this.child,
    this.backgroundColor = MAIN_COLOR,
    this.title,
    this.bottomNavigationBar,
    this.needWillPopScope = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentBackPressTime = ref.watch(willPopScopeTimeProvider);

    return WillPopScope(
      onWillPop: needWillPopScope
          ? () async =>
              DataUtils.onWillPop(currentBackPressTime, ref) //뒤로가기 두번 눌러야 앱 종료,
          : null, // 일반 화면은 그냥 뒤로가기
      child: Scaffold(
        appBar: title != null
            ? AppBar(
                // elevation: 0,
                centerTitle: true,
                scrolledUnderElevation: 0,
                title: Text(title!),
                backgroundColor: backgroundColor,
                foregroundColor: Colors.white,
              )
            : null,
        backgroundColor: backgroundColor,
        body: Padding(
          padding: EdgeInsets.only(bottom: Platform.isIOS ? 0 : 8.0),
          child: ConstrainedScreen(
            child: child,
          ),
        ),
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}
