import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../../../providers/adstate.dart';
import 'widgets/videogrid.dart';

class YoWhatsappVideoPage extends StatelessWidget {
  const YoWhatsappVideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        YoBannerVideoAdBar(),
        Expanded(
          child: YoVideoGrid(),
        ),
      ],
    );
  }
}

class YoBannerVideoAdBar extends StatefulWidget {
  const YoBannerVideoAdBar({super.key});

  @override
  State<YoBannerVideoAdBar> createState() => _YoBannerVideoAdBarState();
}

class _YoBannerVideoAdBarState extends State<YoBannerVideoAdBar>
    with AutomaticKeepAliveClientMixin {
  BannerAd? _bannerAd;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(
      context,
    );
    adState.initialization.then(
      (value) {
        setState(
          () {
            _bannerAd = BannerAd(
              size: AdSize.banner,
              adUnitId: AdState.yovideobannerAdUnitId,
              listener: adState.adListener,
              request: const AdRequest(),
            )..load();
          },
        );
      },
    );
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
