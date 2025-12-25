import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  RewardedAd? _rewardedAd;
  bool _isLoading = false;

  // Test Ad Unit IDs
  final String _androidRewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';
  final String _iosRewardedAdUnitId = 'ca-app-pub-3940256099942544/1712485313';

  // Constructor: Load the ad immediately when the service is created
  AdService() {
    loadRewardedAd();
  }

  String get _adUnitId {
    if (kIsWeb) return ''; // Web not supported for Mobile Ads SDK yet in this context
    if (Platform.isAndroid) {
      return _androidRewardedAdUnitId;
    } else if (Platform.isIOS) {
      return _iosRewardedAdUnitId;
    } else {
      return ''; // Handle other platforms gracefully
    }
  }

  void loadRewardedAd() {
    if (_isLoading || _adUnitId.isEmpty) return;
    _isLoading = true;

    RewardedAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          debugPrint('$ad loaded.');
          _rewardedAd = ad;
          _isLoading = false;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('RewardedAd failed to load: $error');
          _rewardedAd = null;
          _isLoading = false;
        },
      ),
    );
  }

  void showRewardedAd(Function onReward) {
    if (_adUnitId.isEmpty) {
      debugPrint('Ads not supported on this platform');
      return;
    }

    if (_rewardedAd == null) {
      debugPrint('Warning: Ad not ready. Loading now...');
      loadRewardedAd(); // Try loading again
      // Optional: Show a snackbar here telling the user "Ad loading, please try again in a moment"
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          debugPrint('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        debugPrint('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd(); // Preload the next one immediately
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        debugPrint('User earned reward: ${reward.amount} ${reward.type}');
        onReward();
      },
    );
  }
}