import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quiz/common/data/colors.dart';
import 'package:quiz/common/theme/constrained_screen.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final String? title;
  const DefaultLayout({
    super.key,
    required this.child,
    this.backgroundColor = MAIN_COLOR,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
