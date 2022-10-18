import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  Future<InitializationStatus> initialization;

  AdState(this.initialization);

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      final androidBannerID = dotenv.env['AndroidAdd'];
      print(androidBannerID);
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get videobannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4411468910";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  BannerAdListener get adListener => _adListener;

  final BannerAdListener _adListener = BannerAdListener(
    onAdLoaded: (ad) => print('Ad loaded: ${ad.adUnitId}'),
    onAdClosed: (ad) => print('Ad closed: ${ad.adUnitId}'),
    onAdFailedToLoad: (ad, error) =>
        print('Ad failed to loaded: ${ad.adUnitId}, $error'),
    onAdOpened: (ad) => print('Ad opened: ${ad.adUnitId}'),
    onAdClicked: (ad) => print('Ad clicked: ${ad.adUnitId}'),
    onAdImpression: (ad) => print('Ad impression: ${ad.adUnitId}'),
  );
}
