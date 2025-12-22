import 'package:flutter/material.dart';

abstract class Typo {
  final String name;
  final FontWeight light;
  final FontWeight regular;
  final FontWeight semiBold;

  const Typo({
    required this.name,
    required this.light,
    required this.regular,
    required this.semiBold,
  });
}

class NotoSans implements Typo {
  const NotoSans();
  @override
  final String name = 'NotoSans';
  @override
  final FontWeight light = FontWeight.w300;
  @override
  final FontWeight regular = FontWeight.w400;
  @override
  final FontWeight semiBold = FontWeight.w600;
}
