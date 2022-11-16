import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_status_saver/providers/adstate.dart';
import 'package:whatsapp_status_saver/screens/gbwhatsapp/widgets/videos/widgets/videogrid.dart';

class GBWhatsappVideoPage extends StatelessWidget {
  const GBWhatsappVideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        GBWhatsappVideoBannerAdBar(),
        Expanded(
          child: GBVideoGrid(),
        ),
      ],
    );
  }
}

class GBWhatsappVideoBannerAdBar extends StatefulWidget {
  const GBWhatsappVideoBannerAdBar({super.key});

  @override
  State<GBWhatsappVideoBannerAdBar> createState() =>
      GBWhatsappVideoBannerAdBarState();
}

class GBWhatsappVideoBannerAdBarState extends State<GBWhatsappVideoBannerAdBar>
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
          adUnitId: AdState.gbvideobannerAdUnitId,
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
