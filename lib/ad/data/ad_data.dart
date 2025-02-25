import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final isDevMode = (kDebugMode || kProfileMode);

class AdMobService {
  static String get bannerAdUnitId {
    if (isDevMode) {
      if (Platform.isAndroid) {
        return dotenv.env['BANNER_TEST_ID_ANDROID'] ?? '';
      }
      return dotenv.env['BANNER_TEST_ID_IOS'] ?? '';
    } else {
      if (Platform.isAndroid) {
        return dotenv.env['BANNER_ID_ANDROID'] ?? '';
      }
      return dotenv.env['BANNER_ID_IOS'] ?? '';
    }
  }

  static String get interstitialAdId {
    if (isDevMode) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/1033173712';
      }
      return 'ca-app-pub-3940256099942544/4411468910';
    } else {
      if (Platform.isAndroid) {
        return dotenv.env['INTERSTITIAL_ID_ANDROID'] ?? '';
      }
      return dotenv.env['INTERSTITIAL_ID_IOS'] ?? '';
    }
  }

  /// 실제 Ad Unit ID

  static String get rewardedAdId {
    if (isDevMode) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/5224354917';
      }
      return 'ca-app-pub-3940256099942544/1712485313';
    } else {
      if (Platform.isAndroid) {
        return dotenv.env['REWARDED_ID_ANDROID'] ?? '';
      }
      return dotenv.env['REWARDED_ID_IOS'] ?? '';
    }
  }
}
