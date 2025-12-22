import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:quiz/core/const/data.dart';
import 'package:quiz/core/theme/constrained_screen.dart';
import 'package:quiz/core/theme/theme_provider.dart';
import 'package:quiz/core/utils/data_utils.dart';

final willPopScopeTimeProvider = StateProvider<DateTime?>(
  (ref) => null,
);

class DefaultLayout extends ConsumerWidget {
  final Widget child;
  final Color? backgroundColor;
  final String? title;
  final Widget? bottomNavigationBar;
  final bool needWillPopScope;
  const DefaultLayout({
    super.key,
    required this.child,
    this.backgroundColor,
    this.title,
    this.bottomNavigationBar,
    this.needWillPopScope = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentBackPressTime = ref.watch(willPopScopeTimeProvider);
    final theme = ref.read(themeServiceProvider);

    return Scaffold(
      appBar: title == null ? null : AppBar(title: Text(title!)),
      backgroundColor: backgroundColor ?? theme.color.surface,
      body: Padding(
        padding: EdgeInsets.only(bottom: Platform.isIOS ? 0 : 8.0),
        child: ConstrainedScreen(child: child),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
