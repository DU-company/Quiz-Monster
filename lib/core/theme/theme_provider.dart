import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz/core/theme/responsive/layout.dart';
import 'package:quiz/core/theme/responsive/light_theme.dart';

// 그냥 final로 선언해도 되지만, 추후 확장성을 위해..
final themeServiceProvider = Provider((ref) => LightTheme());

final themeProvider = Provider((ref) {
  final theme = ref.read(themeServiceProvider);
  return ThemeData(
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: theme.color.onPrimary,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: theme.color.secondary,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      constraints: BoxConstraints(maxWidth: Breakpoints.bottomSheet),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      scrolledUnderElevation: 0,
      titleTextStyle: theme.typo.headline6,
      backgroundColor: theme.color.primary,
      foregroundColor: theme.color.onPrimary,
    ),
  );
});
