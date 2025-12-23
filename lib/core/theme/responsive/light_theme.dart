import 'package:flutter/material.dart';
import 'package:quiz/core/theme/app_theme.dart';
import 'package:quiz/core/theme/color/app_color.dart';
import 'package:quiz/core/theme/color/app_deco.dart';
import 'package:quiz/core/theme/color/palette.dart';
import 'package:quiz/core/theme/typo/app_typo.dart';
import 'package:quiz/core/theme/typo/typo.dart';

class LightTheme implements AppTheme {
  LightTheme();

  @override
  Brightness brightness = Brightness.light;

  @override
  AppColor color = AppColor(
    /// Surface
    surface: Palette.red,
    background: Palette.black.withValues(alpha: 0.55),

    /// Text
    text: Palette.white,
    subtext: Palette.grey700,

    /// Toast
    toastContainer: Palette.black.withValues(alpha: 0.85),
    onToastContainer: Palette.grey100,

    /// Hint
    hint: Palette.grey300,
    hintContainer: Palette.grey200,
    onHintContainer: Palette.grey500,

    /// Inactive
    inactive: Palette.grey500,
    inactiveContainer: Palette.grey600,
    onInactiveContainer: Palette.white,

    /// Accent
    primary: Palette.red,
    onPrimary: Palette.white,
    secondary: Palette.black,
    onSecondary: Palette.white,
    tertiary: Palette.yellow,
    onTertiary: Palette.white,
  );

  @override
  late AppTypo typo = AppTypo(
    typo: NotoSans(),
    fontColor: color.text,
  );

  @override
  AppDeco deco = AppDeco(
    shadow: [
      BoxShadow(
        color: Palette.black.withValues(alpha: 0.15),
        blurRadius: 35,
      ),
    ],
  );
}
