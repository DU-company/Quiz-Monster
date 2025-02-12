import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz/common/component/custom_indicator.dart';
import 'package:quiz/common/component/primary_button.dart';

import '../../home/screen/home_screen.dart';
import '../model/pagination_model.dart';
import '../screen/default_layout.dart';

class PaginationScreen extends StatelessWidget {
  final QuizPaginationBase data;
  PaginationScreen({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/img/eyes.png'),
          const SizedBox(height: 32),
          if (data is QuizPaginationLoading)
            Center(
              child: CustomIndicator(),
            ),
          if (data is QuizPaginationError)
            Column(
              children: [
                Center(
                  child: Text(
                    '게임을 불러올 수 없습니다.\n네트워크 연결을 확인해주세요!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  label: '홈으로',
                  onPressed: () {
                    context.goNamed(HomeScreen.routeName);
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}
