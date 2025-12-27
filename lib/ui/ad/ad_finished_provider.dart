import 'package:flutter_riverpod/flutter_riverpod.dart';

final adFinishedProvider = NotifierProvider(
  () => AdFinishedProvider(),
);

class AdFinishedProvider extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void onFinish() {
    state = true;
  }

  void onReset() {
    state = false;
  }
}
