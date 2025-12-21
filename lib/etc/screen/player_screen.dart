import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quiz/ui/common/widgets/primary_button.dart';
import 'package:quiz/core/utils/data_utils.dart';
import 'package:quiz/etc/provider/player_provider.dart';
import 'package:quiz/etc/screen/default_etc_screen.dart';
import 'package:quiz/setting/screen/responsive_screen.dart';
import 'package:quiz/time/screen/time_count_screen.dart';

import '../../ad/provider/ad_count_provider.dart';
import '../../ad/provider/interstitial_ad_provider.dart';

class PlayerScreen extends ConsumerWidget {
  static String routeName = 'player';
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interstitialAd = ref.watch(interstitialAdProvider);
    final adCount = ref.watch(adCountProvider);
    final players = ref.watch(playerProvider);

    // print('adCount: $adCount');

    return ResponsiveSettingScreen(
      label: '참가자 수를\n선택해 주세요',
      body: _Body(
        onSubPressed: players <= 3 ? null : () => onSubPressed(ref),
        onAddPressed: players >= 30 ? null : () => onAddPressed(ref),
        players: players,
      ),
      footer: _Footer(
        onPressed: () {
          if (interstitialAd == null || adCount < 3) {
            context.goNamed(DefaultEtcScreen.routeName);
            ref.read(adCountProvider.notifier).addCount();
          } else {
            ref.read(adCountProvider.notifier).resetCount();

            /// 광고를 띄운다
            DataUtils.showInterstitialAd(
              interstitialAd: interstitialAd,
              moveToScreen: () => context.goNamed(DefaultEtcScreen.routeName),
            );
          }
        },
      ),
    );
  }

  void onSubPressed(WidgetRef ref) {
    ref.read(playerProvider.notifier).update((state) => state - 1);
  }

  void onAddPressed(WidgetRef ref) {
    ref.read(playerProvider.notifier).update((state) => state + 1);
  }
}

class _Body extends StatelessWidget {
  final VoidCallback? onAddPressed;
  final VoidCallback? onSubPressed;
  final int players;
  const _Body({
    super.key,
    required this.onAddPressed,
    required this.onSubPressed,
    required this.players,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PrimaryButton(
          label: '−',
          onPressed: onSubPressed,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            '$players',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontFamily: 'Roboto',
            ),
          ),
        ),
        PrimaryButton(
          label: '+',
          fontColor: Colors.white,
          onPressed: onAddPressed,
        ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  final VoidCallback onPressed;
  const _Footer({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      label: '시작하기',
      onPressed: onPressed,
    );
  }
}
