import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitalAdWidget extends StatefulWidget {
  const InterstitalAdWidget({super.key});

  @override
  State<InterstitalAdWidget> createState() => _InterstitalAdWidgetState();
}

class _InterstitalAdWidgetState extends State<InterstitalAdWidget> {
  late InterstitialAd _interstitialAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _initAd();
  }

  void _initAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-9078201720890090/1701830991',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: (error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  void onAdLoaded(InterstitialAd ad) {
    _interstitialAd = ad;
    setState(() {
      _isLoaded = true;
    });

    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
      },
    );
  }

  showInterstitialAd() {
    if (_isLoaded) {
      return _interstitialAd.show();
    } else {
      return (Text("Interstitial ad is not loaded yet."),);
    }
  }

  @override
  Widget build(BuildContext context) {
    return showInterstitialAd();
  }
}
