import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_status_saver/providers/adstate.dart';
import 'package:whatsapp_status_saver/screens/yowhatsapp/widgets/videos/widgets/videogrid.dart';

class YoWhatsappVideoPage extends StatefulWidget {
  const YoWhatsappVideoPage({super.key});

  @override
  State<YoWhatsappVideoPage> createState() => _YoWhatsappVideoPageState();
}

class _YoWhatsappVideoPageState extends State<YoWhatsappVideoPage> {
  BannerAd? _bannerAd;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(
      context,
    );
    adState.initialization.then((value) {
      setState(() {
        _bannerAd = BannerAd(
          size: AdSize.banner,
          adUnitId: AdState.yovideobannerAdUnitId,
          listener: adState.adListener,
          request: const AdRequest(),
        )..load();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_bannerAd != null)
          Container(
            color: Colors.white,
            child: SizedBox(
              height: 50,
              child: AdWidget(ad: _bannerAd!),
            ),
          ),
        const Expanded(
          child: YoVideoGrid(),
        ),
      ],
    );
  }
}
