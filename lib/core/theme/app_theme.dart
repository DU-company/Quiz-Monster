import 'package:flutter/material.dart';
import 'package:quiz_monster/core/theme/color/app_color.dart';
import 'package:quiz_monster/core/theme/color/app_deco.dart';
import 'package:quiz_monster/core/theme/typo/app_typo.dart';

abstract class AppTheme {
  late final Brightness brightness;
  late final AppColor color;
  late final AppDeco deco;
  late final AppTypo typo;
}
