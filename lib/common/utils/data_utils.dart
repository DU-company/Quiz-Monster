import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../screen/default_layout.dart';

class DataUtils {
  static void showToast({required String msg}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 18.0,
    );
  }

  static String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    if (seconds > 9) {
      return '$seconds';
    } else {
      return seconds.toString().padLeft(2, '0');
    }
    return "${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  static Future<bool> onWillPop(DateTime? currentBackPressTime, WidgetRef ref) {
    DateTime now = DateTime.now();

    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      ref.read(willPopScopeTimeProvider.notifier).state = now;
      const msg = "'뒤로' 버튼을 한 번 더 누르면 종료됩니다.";

      Fluttertoast.showToast(msg: msg, backgroundColor: Colors.grey);
      return Future.value(false);
    }

    return Future.value(true);
  }

  static showInterstitialAd({
    required InterstitialAd interstitialAd,
    required VoidCallback moveToScreen,
  }) {
    interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) => moveToScreen(),
      onAdFailedToShowFullScreenContent: (ad, error) {
        print(error);
        moveToScreen();
      },
    );
    interstitialAd.show();
  }
}
