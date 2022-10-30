import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  Future<InitializationStatus> initialization;

  AdState(this.initialization);

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      final androidTestBannerID = dotenv.env['whatsappad'];
      return androidTestBannerID!;
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get yobannerAdUnitId {
    if (Platform.isAndroid) {
      final androidTestBannerID = dotenv.env['yowhatsappad'];
      return androidTestBannerID!;
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get businessbannerAdUnitId {
    if (Platform.isAndroid) {
      final androidTestBannerID = dotenv.env['businesswhatsappad'];
      return androidTestBannerID!;
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get gbbannerAdUnitId {
    if (Platform.isAndroid) {
      final androidTestBannerID = dotenv.env['gbwhatsappad'];
      return androidTestBannerID!;
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get videobannerAdUnitId {
    if (Platform.isAndroid) {
      final androidTestBannerID = dotenv.env['videowhatsapp'];
      return androidTestBannerID!;
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get businessvideobannerAdUnitId {
    if (Platform.isAndroid) {
      final androidTestBannerID = dotenv.env['businessvideowhatsapp'];
      return androidTestBannerID!;
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get yovideobannerAdUnitId {
    if (Platform.isAndroid) {
      final androidTestBannerID = dotenv.env['yovideowhatsapp'];
      return androidTestBannerID!;
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get gbvideobannerAdUnitId {
    if (Platform.isAndroid) {
      final androidTestBannerID = dotenv.env['gbwhatsappvideoad'];
      return androidTestBannerID!;
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      final androidTestBannerID = dotenv.env['interstitialadd'];
      return androidTestBannerID!;
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4411468910";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get yointerstitialAdUnitId {
    if (Platform.isAndroid) {
      final androidTestBannerID = dotenv.env['yowhatsappinterstitialadds'];
      return androidTestBannerID!;
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4411468910";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get businessinterstitialAdUnitId {
    if (Platform.isAndroid) {
      final androidTestBannerID = dotenv.env['businesswhatsappinterstitialadd'];
      return androidTestBannerID!;
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4411468910";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get gbinterstitialAdUnitId {
    if (Platform.isAndroid) {
      final androidTestBannerID = dotenv.env['gbwhatsappinterstitialadd'];
      return androidTestBannerID!;
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
