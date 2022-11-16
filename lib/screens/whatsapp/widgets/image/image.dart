import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_status_saver/screens/widgets/image/singleimage.dart';

import '../../../../directory_response/check_directory_response.dart';
import '../../../../providers/adstate.dart';
import '../../../../providers/get_statuses_provider.dart';
import 'image_view.dart';

class WhatsappImagePage extends StatelessWidget {
  const WhatsappImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const WhatsappBannerAdBar(),
          Expanded(
            child: Consumer<GetStatusProvider>(
              builder: (context, file, child) {
                if (file.itemsData.status == Status.COMPLETED &&
                    file.getImages.isNotEmpty) {
                  return GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: MediaQuery.of(context).size.width / 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: 2.5 / 3,
                    ),
                    padding: const EdgeInsets.all(8),
                    itemCount: file.getImages.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          file
                              .findPersonUsingIndexWhere(
                                  file.getImages[index].status.path)
                              .then(
                                (value) => Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        ImagePageView(imageIndex: value),
                                  ),
                                ),
                              );
                        },
                        child: SingleGridImage(
                          filePath: file.getImages[index].status.path,
                        ),
                      );
                    },
                  );
                } else if (file.itemsData.status == Status.ERROR) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            file.itemsData.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              letterSpacing: .5,
                              fontSize: 17,
                            ),
                            semanticsLabel: file.itemsData.message,
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (file.itemsData.status == Status.LOADING) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            file.itemsData.message,
                            style: TextStyle(fontSize: 15),
                          ),
                        )
                      ],
                    ),
                  );
                } else if (file.getImages.isEmpty) {
                  return const Center(
                    child: Text(
                      'No recently viewed pictures',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        letterSpacing: .5,
                        fontSize: 15,
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      'Something went wrong',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        letterSpacing: .5,
                        fontSize: 15,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WhatsappBannerAdBar extends StatefulWidget {
  const WhatsappBannerAdBar({super.key});

  @override
  State<WhatsappBannerAdBar> createState() => _WhatsappBannerAdBarState();
}

class _WhatsappBannerAdBarState extends State<WhatsappBannerAdBar>
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
        setState(() {
          _bannerAd = BannerAd(
            size: AdSize.banner,
            adUnitId: AdState.bannerAdUnitId,
            listener: adState.adListener,
            request: const AdRequest(),
          )..load();
        });
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
