import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final isDevMode = (kDebugMode || kProfileMode);

class AdMobService {
  static String get bannerAdUnitId {
    if (isDevMode) {
      if (Platform.isIOS) return dotenv.env['BANNER_TEST_ID_IOS']!;
      return dotenv.env['BANNER_TEST_ID_ANDROID']!;
    }

    /// Release Model
    if (Platform.isIOS) return dotenv.env['BANNER_ID_IOS']!;
    return dotenv.env['BANNER_ID_ANDROID']!;
  }

  static String get interstitialAdId {
    if (isDevMode) {
      if (Platform.isIOS) return 'ca-app-pub-3940256099942544/4411468910';
      return 'ca-app-pub-3940256099942544/1033173712';
    }

    /// Release Model
    if (Platform.isIOS) return dotenv.env['INTERSTITIAL_ID_IOS']!;
    return dotenv.env['INTERSTITIAL_ID_ANDROID']!;
  }

  static String get rewardedAdId {
    if (isDevMode) {
      if (Platform.isIOS) return 'ca-app-pub-3940256099942544/1712485313';
      return 'ca-app-pub-3940256099942544/5224354917';
    }

    /// Release Model
    if (Platform.isIOS) return dotenv.env['REWARDED_ID_IOS']!;
    return dotenv.env['REWARDED_ID_ANDROID']!;
  }
}
