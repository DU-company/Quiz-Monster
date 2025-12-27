import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quiz/core/service/ad_service.dart';

final bannerAdViewModelProvider = NotifierProvider.autoDispose(
  () => BannerAdViewModel(),
);

class BannerAdViewModel extends Notifier<BannerAd?> {
  @override
  BannerAd? build() {
    getBannerAd();
    return null;
  }

  BannerAd? bannerAd;

  void getBannerAd() {
    bannerAd = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          state = bannerAd;
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
          state = null;
        },
        onAdClosed: (ad) {
          ad.dispose();
          state = null;
        },
      ),
      request: const AdRequest(),
    )..load();
  }
}
