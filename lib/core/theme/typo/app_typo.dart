import 'package:flutter/material.dart';
import 'package:quiz/core/theme/typo/typo.dart';

class AppTypo {
  /// Typo
  final Typo typo;

  /// Font Color
  final Color fontColor;

  AppTypo({required this.typo, required this.fontColor});

  /// Font Weight
  late FontWeight light = typo.light;
  late FontWeight regular = typo.regular;
  late FontWeight semiBold = typo.semiBold;

  /// Headline
  late final TextStyle headline1 = TextStyle(
    height: 1.3,
    fontFamily: typo.name,
    fontWeight: typo.semiBold,
    fontSize: 24,
    color: fontColor,
  );
  late final TextStyle headline2 = TextStyle(
    height: 1.3,
    fontFamily: typo.name,
    fontWeight: typo.semiBold,
    fontSize: 22,
    color: fontColor,
  );
  late final TextStyle headline3 = TextStyle(
    height: 1.3,
    fontFamily: typo.name,
    fontWeight: typo.semiBold,
    fontSize: 21,
    color: fontColor,
  );
  late final TextStyle headline4 = TextStyle(
    height: 1.3,
    fontFamily: typo.name,
    fontWeight: typo.semiBold,
    fontSize: 20,
    color: fontColor,
  );
  late final TextStyle headline5 = TextStyle(
    height: 1.3,
    fontFamily: typo.name,
    fontWeight: typo.semiBold,
    fontSize: 19,
    color: fontColor,
  );
  late final TextStyle headline6 = TextStyle(
    height: 1.3,
    fontFamily: typo.name,
    fontWeight: typo.regular,
    fontSize: 18,
    color: fontColor,
  );

  /// Subtitle
  late final TextStyle subtitle1 = TextStyle(
    height: 1.3,
    fontFamily: typo.name,
    fontWeight: typo.regular,
    fontSize: 17,
    color: fontColor,
  );
  late final TextStyle subtitle2 = TextStyle(
    height: 1.3,
    fontFamily: typo.name,
    fontWeight: typo.regular,
    fontSize: 16,
    color: fontColor,
  );

  /// Body
  late final TextStyle body1 = TextStyle(
    height: 1.3,
    fontFamily: typo.name,
    fontWeight: typo.light,
    fontSize: 14,
    color: fontColor,
  );
  late final TextStyle body2 = TextStyle(
    height: 1.3,
    fontFamily: typo.name,
    fontWeight: typo.light,
    fontSize: 13,
    color: fontColor,
  );
  late final TextStyle body3 = TextStyle(
    height: 1.3,
    fontFamily: typo.name,
    fontWeight: typo.light,
    fontSize: 12,
    color: fontColor,
  );
}
