import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:quiz/ui/common/widgets/loading_widget.dart';
import 'package:quiz/ui/common/widgets/primary_button.dart';
import 'package:quiz/core/theme/responsive/layout.dart';
import 'package:quiz/ui/quiz/detail/quiz_detail_success_view.dart';
import 'package:quiz/ui/common/layout/quiz_detail_layout.dart';
import 'package:quiz/ui/settings/level/level_provider.dart';

class FlyScreen extends ConsumerStatefulWidget {
  final VoidCallback showAnswerPressed;
  final VoidCallback onReplay;
  final int remainingSeconds;
  const FlyScreen({
    super.key,
    required this.showAnswerPressed,
    required this.onReplay,
    required this.remainingSeconds,
  });
  @override
  _FlyScreenState createState() => _FlyScreenState();
}

class _FlyScreenState extends ConsumerState<FlyScreen> {
  final Random _random = Random();
  late int flyCount;
  List<Offset>? flyPositions;
  double? _width;
  double? _height;

  @override
  void initState() {
    super.initState();
    _generateFlies();
  }

  void _generateFlies() {
    final level = ref.read(levelProvider);
    if (level == null) {
      flyCount = _random.nextInt(19) + 5; // 5~24마리 사이 랜덤 개수
    } else if (level == 1) {
      flyCount = _random.nextInt(5) + 5; // 5~10마리 사이 랜덤 개수
    } else if (level == 2) {
      flyCount = _random.nextInt(9) + 7; // 7~16마리 사이 랜덤 개수
    } else if (level == 3) {
      flyCount = _random.nextInt(14) + 10; // 10~24마리 사이 랜덤 개수
    }
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _width = MediaQuery.of(context).size.width / 1.5;
        _height = MediaQuery.of(context).size.height / 2;

        if (_width != null && _height != null) {
          setState(() {
            flyPositions = List.generate(
              flyCount,
              (index) => Offset(
                _random.nextDouble() * _width!, // X 좌표 (화면 크기에 맞게 조정)
                _random.nextDouble() * _height!, // Y 좌표
              ),
            );
          });
        } else {
          print('Error');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final showAnswer = ref.watch(showAnswerProvider);

    if (flyPositions == null) {
      return LoadingWidget();
    } else {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  // 랜덤하게 배치된 파리들
                  ...flyPositions!.map(
                    (pos) => Positioned(
                      left: pos.dx,
                      top: pos.dy,
                      child: Image.asset(
                        'assets/img/fly.png',
                        width: context.layout(80, mobile: 64),
                        height: context.layout(80, mobile: 64),
                      ),
                    ),
                  ),
                  // 정답 확인 버튼
                ],
              ),
            ),
            _TimeOver(remainingSeconds: widget.remainingSeconds),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: PrimaryButton(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.black,
                    label: '새로 고침',
                    child: Icon(
                      Icons.refresh,
                      size: 24,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      _generateFlies();
                      widget.onReplay();
                    },
                  ),
                ),
                Expanded(
                  child: Text(
                    showAnswer ? '$flyCount 마리' : '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: context.layout(48, mobile: 18),
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Expanded(
                  child: PrimaryButton(
                    label: '정답',
                    onPressed: widget.showAnswerPressed,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}

class _TimeOver extends StatelessWidget {
  final int remainingSeconds;
  const _TimeOver({
    super.key,
    required this.remainingSeconds,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        remainingSeconds == 0 ? '💣 TIME OVER 💣' : "",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 32,
          fontFamily: 'Roboto',
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
