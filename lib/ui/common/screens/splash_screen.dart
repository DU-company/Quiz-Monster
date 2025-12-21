import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz/ui/common/widgets/custom_indicator.dart';
import 'package:quiz/ui/pagination/pagination_screen.dart';
import 'package:quiz/data/models/pagination_state.dart';
import 'package:quiz/ui/common/layout/default_layout.dart';
import 'package:quiz/home/screen/home_screen.dart';
import 'package:quiz/quiz/model/quiz_model.dart';
import 'package:quiz/quiz/provider/quiz_provider.dart';

class SplashScreen extends ConsumerWidget {
  static String routeName = 'splash';
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(quizProvider);

    if (data is PaginationSuccess<QuizModel>) {
      return HomeScreen();
    }

    return PaginationScreen(data: data);
  }
}
