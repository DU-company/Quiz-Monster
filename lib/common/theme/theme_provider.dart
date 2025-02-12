import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz/common/data/colors.dart';
import 'package:quiz/common/theme/layout.dart';

final themeProvider = Provider(
  (ref) => ThemeData(
    fontFamily: "NotoSans",
    // scaffoldBackgroundColor: MAIN_COLOR,
    /// 일반 Text
    textTheme: TextTheme(
      bodyLarge: TextStyle(
          fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white),
      bodyMedium: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      bodySmall: TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: 14,
      ),

      /// 버튼 위의 Text
      labelLarge: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),

      /// AppBar 혹은 Dialog의 Title
      titleLarge: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: Colors.black,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      constraints: BoxConstraints(
        maxWidth: Breakpoints.bottomSheet,
      ),
    ),
  ),
);
