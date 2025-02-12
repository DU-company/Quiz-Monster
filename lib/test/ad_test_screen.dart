import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quiz/ad/provider/ad_provider.dart';
import 'package:quiz/common/component/primary_button.dart';

class AdTestScreen extends ConsumerWidget {
  const AdTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adState = ref.watch(adStateNotifierProvider);
    final isBannerAd = adState is BannerAd;
    print(adState);
    return Scaffold(
      bottomNavigationBar: isBannerAd
          ? SizedBox(
              height: 100,
              child: AdWidget(
                ad: adState,
              ),
            )
          : Container(
              height: 100,
            ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: PrimaryButton(
              label: '다음 게임',
              onPressed: () {
                // ref
                //     .read(adStateNotifierProvider.notifier)
                //     .loadInterstitialAd();
                // if (adState is InterstitialAd) {
                //   adState.fullScreenContentCallback = FullScreenContentCallback(
                //     onAdDismissedFullScreenContent: (ad) {
                //       ad.dispose();
                //     },
                //     onAdFailedToShowFullScreenContent: (ad, error) {
                //       ad.dispose();
                //     },
                //   );
                //   adState.show();
                //   ref.read(adStateNotifierProvider.notifier).setToNull();
                // }
                if (adState is RewardedAd) {
                  adState.show(
                    onUserEarnedReward: (ad, reward) {
                      print('Reward amout: ${reward.amount}');
                    },
                  );
                    ref.read(adStateNotifierProvider.notifier).setToNull();

                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
