import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../../../providers/adstate.dart';
import 'widgets/videogrid.dart';

class BusinessWhatsappVideoPage extends StatelessWidget {
  const BusinessWhatsappVideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        BusinessWhatsappVideoBannerAdBar(),
        Expanded(
          child: BusinessVideoGrid(),
        ),
      ],
    );
  }
}

class BusinessWhatsappVideoBannerAdBar extends StatefulWidget {
  const BusinessWhatsappVideoBannerAdBar({super.key});

  @override
  State<BusinessWhatsappVideoBannerAdBar> createState() =>
      _BusinessWhatsappVideoBannerAdBarState();
}

class _BusinessWhatsappVideoBannerAdBarState
    extends State<BusinessWhatsappVideoBannerAdBar>
    with AutomaticKeepAliveClientMixin {
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
    super.build(context);
    return Container(
      child: _bannerAd != null
          ? Container(
              color: Colors.white,
              child: SizedBox(
                height: 50,
                child: AdWidget(ad: _bannerAd!),
              ),
            )
          : Container(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
