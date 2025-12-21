import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:quiz/time/provider/time_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ⏳ 2. Riverpod Provider
final timerProvider = StateNotifierProvider<TimerNotifier, int>((ref) {
  final time = ref.watch(timeProvider);
  final min = time.inMinutes.remainder(60);
  final sec = time.inSeconds.remainder(60);
  return TimerNotifier(selectedTime: min * 60 + sec);
});

// ⏳ 1. StateNotifier: 타이머 상태를 관리하는 Provider
class TimerNotifier extends StateNotifier<int> {
  final int selectedTime;
  Timer? _timer;

  TimerNotifier({
    required this.selectedTime,
  }) : super(selectedTime) {
    restartTimer(); // 생성과 동시에 타이머 시작
  }

  void restartTimer() {
    _timer?.cancel(); // 기존 타이머 중지
    state = selectedTime; // 시간을 초기값으로 리셋
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (state > 0) {
        state--; // 1초씩 감소 (자동으로 UI 갱신됨)
      } else {
        _timer?.cancel();
      }
    });
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (state > 0) {
        state--; // 1초씩 감소 (자동으로 UI 갱신됨)
      } else {
        _timer?.cancel();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Provider가 제거될 때 타이머 정리
    super.dispose();
  }
}
