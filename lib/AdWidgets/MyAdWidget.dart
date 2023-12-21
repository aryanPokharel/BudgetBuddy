import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyAdWidget extends StatefulWidget {
  const MyAdWidget({super.key});

  @override
  State<MyAdWidget> createState() => _MyAdWidgetState();
}

class _MyAdWidgetState extends State<MyAdWidget> {
  @override
  void initState() {
    super.initState();
    _initBannerAd();
  }

  // Working with ads
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;
  var adUnit = 'ca-app-pub-9078201720890090/1438268814';
  // var adUnit = 'ca-app-pub-3940256099942544/6300978111';

  _initBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnit,
      listener: BannerAdListener(onAdLoaded: (ad) {
        setState(() {
          _isAdLoaded = true;
        });
      }, onAdFailedToLoad: (ad, error) {
        ad.dispose();
        print(error);
      }),
      request: const AdRequest(),
    );

    _bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: _isAdLoaded
          ? Container(
              width: 470,
              height: 62,
              child: AdWidget(ad: _bannerAd),
            )
          : null,
    );
  }
}
