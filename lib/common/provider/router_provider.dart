import 'dart:ffi';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz/common/screen/splash_screen.dart';
import 'package:quiz/home/screen/home_screen.dart';
import 'package:quiz/like/screen/like_screen.dart';
import 'package:quiz/setting/screen/level_screen.dart';
import 'package:quiz/quiz/screen/default_quiz_screen.dart';
import 'package:quiz/quiz/screen/result_screen.dart';
import 'package:quiz/time/screen/time_count_screen.dart';
import 'package:quiz/time/screen/time_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../setting/screen/pass_screen.dart';
import '../../test/test_screen.dart';

final goRouterProvider = Provider(
  (ref) {
    return GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(
            path: '/',
            builder: (context, state) => HomeScreen(),
            name: HomeScreen.routeName,
            routes: [
              GoRoute(
                path: '/like',
                builder: (context, state) => LikeScreen(),
                name: LikeScreen.routeName,
              )
            ]),
        GoRoute(
          path: '/splash',
          builder: (context, state) => SplashScreen(),
          name: SplashScreen.routeName,
        ),
        GoRoute(
          path: '/pass',
          builder: (context, state) => PassScreen(),
          name: PassScreen.routeName,
        ),
        GoRoute(
          path: '/level',
          builder: (context, state) => LevelScreen(),
          name: LevelScreen.routeName,
        ),
        GoRoute(
            path: '/time',
            name: TimeScreen.routeName,
            builder: (context, state) => TimeScreen()),
        GoRoute(
          path: '/timeCount',
          name: TimeCountScreen.routeName,
          builder: (context, state) => TimeCountScreen(),
        ),
        GoRoute(
          path: '/quiz',
          builder: (context, state) => DefaultQuizScreen(),
          name: DefaultQuizScreen.routeName,
        ),
        GoRoute(
          path: '/result',
          builder: (context, state) => ResultScreen(),
          name: ResultScreen.routeName,
        ),
        GoRoute(
          path: '/test',
          builder: (context, state) => TestScreen(),
          name: TestScreen.routeName,
        ),
      ],
    );
  },
);
