import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_monster/data/entities/quiz_detail_entity.dart';
import 'package:quiz_monster/data/models/quiz_detail_model.dart';
import 'package:quiz_monster/data/models/quiz_model.dart';
import 'package:quiz_monster/ui/common/screens/home_screen.dart';
import 'package:quiz_monster/ui/quiz/etc/liar/liar_screen.dart';
import 'package:quiz_monster/ui/settings/player/set_player_screen.dart';
import 'package:quiz_monster/ui/quiz/etc/reaction/reaction_rate_screen.dart';

import 'package:quiz_monster/ui/wishlist/wishlist_screen.dart';
import 'package:quiz_monster/ui/quiz/detail/quiz_detail_screen.dart';
import 'package:quiz_monster/ui/settings/level/set_level_screen.dart';
import 'package:quiz_monster/ui/quiz/detail/widgets/quiz_detail_success_view.dart';
import 'package:quiz_monster/ui/quiz/pass/pass_result_screen.dart';
import 'package:quiz_monster/ui/settings/time/time_count_screen.dart';
import 'package:quiz_monster/ui/settings/time/set_time_screen.dart';
import '../../ui/settings/pass/set_pass_screen.dart';
import '../../test/test_screen.dart';

final goRouterProvider = Provider((ref) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        builder: (_, _) => HomeScreen(),
        name: HomeScreen.routeName,
        routes: [
          GoRoute(
            path: 'wishlist',
            builder: (_, state) {
              final items = state.extra as List<QuizModel>;
              return WishlistScreen(items);
            },
            name: WishlistScreen.routeName,
          ),
        ],
      ),

      GoRoute(
        path: '/test',
        builder: (_, _) => TestScreen(),
        name: TestScreen.routeName,
      ),

      /// Settings
      GoRoute(
        path: '/pass',
        builder: (_, _) => SetPassScreen(),
        name: SetPassScreen.routeName,
      ),
      GoRoute(
        path: '/level',
        builder: (_, _) => LevelScreen(),
        name: LevelScreen.routeName,
      ),
      GoRoute(
        path: '/time',
        name: TimeScreen.routeName,
        builder: (_, _) => TimeScreen(),
      ),
      GoRoute(
        path: '/player',
        builder: (_, _) => PlayerScreen(),
        name: PlayerScreen.routeName,
      ),
      GoRoute(
        path: '/time-count',
        name: TimeCountScreen.routeName,
        builder: (_, _) => TimeCountScreen(),
      ),

      /// Quiz
      GoRoute(
        path: '/quiz-detail/:qid',
        name: QuizDetailScreen.routeName,
        builder: (_, state) {
          final qid = int.parse(state.pathParameters['qid']!);
          return QuizDetailScreen(qid);
        },
      ),
      GoRoute(
        path: '/result',
        builder: (_, _) => ResultScreen(),
        name: ResultScreen.routeName,
      ),

      GoRoute(
        path: '/reaction',
        builder: (_, _) => ReactionRateScreen(),
        name: ReactionRateScreen.routeName,
      ),
    ],
  );
});
