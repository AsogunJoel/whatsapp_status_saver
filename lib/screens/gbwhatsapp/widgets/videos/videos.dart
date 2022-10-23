import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_status_saver/providers/adstate.dart';
import 'package:whatsapp_status_saver/screens/gbwhatsapp/widgets/videos/widgets/videogrid.dart';

class GBWhatsappVideoPage extends StatefulWidget {
  const GBWhatsappVideoPage({super.key});

  @override
  State<GBWhatsappVideoPage> createState() => _GBWhatsappVideoPageState();
}

class _GBWhatsappVideoPageState extends State<GBWhatsappVideoPage> {
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
          adUnitId: AdState.videobannerAdUnitId,
          listener: adState.adListener,
          request: const AdRequest(),
        )..load();
      });
    });
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
          child: GBVideoGrid(),
        ),
      ],
    );
  }
}
