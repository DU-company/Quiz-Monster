import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz/ui/common/layout/default_layout.dart';
import 'package:quiz/ui/quiz/base/quiz_screen.dart';

class HomeScreen extends ConsumerWidget {
  static String get routeName => 'home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(child: QuizScreen());
  }
}
