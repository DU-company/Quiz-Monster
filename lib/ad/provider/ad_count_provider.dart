import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Shared로 마이그레이션
final adCountProvider = NotifierProvider(() => AdCountNotifier());

class AdCountNotifier extends Notifier<int> {
  @override
  int build() {
    getCurrentCount();
    return 1;
  }

  Future<void> getCurrentCount() async {
    final pref = await SharedPreferences.getInstance();

    final count = pref.get('adCount') as int?;

    if (count == null) {
      await pref.setInt('adCount', 1);
      state = 1;
    } else {
      state = count;
    }
  }

  Future<void> increaseCount() async {
    final pref = await SharedPreferences.getInstance();
    final count = pref.get('adCount') as int;

    // 3번 보면 초기화
    if (count == 3) {
      resetCount();
    } else {
      // 1씩 누적
      pref.setInt('adCount', count + 1);
      state = count + 1;
    }
  }

  Future<void> resetCount() async {
    final pref = await SharedPreferences.getInstance();
    final count = pref.get('adCount') as int?;

    if (count != null) {
      await pref.setInt('adCount', 1);
      state = 1;
    }
  }
}
