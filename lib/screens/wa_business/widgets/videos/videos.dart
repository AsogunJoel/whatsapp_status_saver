import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../../../providers/adstate.dart';
import 'widgets/videogrid.dart';

class BusinessWhatsappVideoPage extends StatefulWidget {
  const BusinessWhatsappVideoPage({super.key});

  @override
  State<BusinessWhatsappVideoPage> createState() =>
      _BusinessWhatsappVideoPageState();
}

class _BusinessWhatsappVideoPageState extends State<BusinessWhatsappVideoPage> {
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
          adUnitId: AdState.businessvideobannerAdUnitId,
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
          child: BusinessVideoGrid(),
        ),
      ],
    );
  }
}
