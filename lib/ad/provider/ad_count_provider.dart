import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive_flutter/hive_flutter.dart';

final adCountProvider = StateNotifierProvider<AdCountStateNotifier, int>(
    (ref) => AdCountStateNotifier());

class AdCountStateNotifier extends StateNotifier<int> {
  AdCountStateNotifier() : super(1);

  /// 3번마다 광고를 보여주게 하기위한 count
  Future<void> addCount() async {
    final box = await Hive.openBox<int>('adCount');
    final count = box.get('count');

    if (count == null) {
      await box.put('count', 2);
      state = 2;
    } else {
      await box.put('count', count + 1);
      state = count + 1;
    }
  }

  Future<void> resetCount() async {
    final box = await Hive.openBox<int>('adCount');
    final count = box.get('count');

    if (count != null) {
      await box.put('count', 1);
      state = 1;
    }
  }
}
