import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz/ui/common/widgets/custom_indicator.dart';
import 'package:quiz/ui/common/widgets/primary_button.dart';

import '../../home/screen/home_screen.dart';
import '../../data/models/pagination_state.dart';
import '../common/layout/default_layout.dart';

/// View로 만들기
class PaginationScreen extends StatelessWidget {
  final PaginationState data;
  PaginationScreen({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      needWillPopScope: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/img/eyes.png'),
          const SizedBox(height: 32),
          if (data is PaginationLoading)
            Center(
              child: CustomIndicator(),
            ),
          if (data is PaginationError)
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
