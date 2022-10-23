import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_status_saver/providers/gb_provider.dart';
import 'package:whatsapp_status_saver/screens/gbwhatsapp/widgets/image/image_view.dart';

import '../../../../directory_response/check_directory_response.dart';
import '../../../../providers/adstate.dart';
import '../../../widgets/image/singleimage.dart';

class GBWhatsappImagePage extends StatefulWidget {
  const GBWhatsappImagePage({super.key});

  @override
  State<GBWhatsappImagePage> createState() => _GBWhatsappImagePageState();
}

class _GBWhatsappImagePageState extends State<GBWhatsappImagePage> {
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
    return Scaffold(
      body: Column(
        children: [
          if (_bannerAd != null)
            Container(
              color: Colors.white,
              child: SizedBox(
                height: 50,
                child: AdWidget(ad: _bannerAd!),
              ),
            ),
          Expanded(
            child: Consumer<GBStatusProvider>(
              builder: (context, file, child) {
                if (file.itemsData.status == Status.COMPLETED &&
                    file.gbgetImages.isNotEmpty) {
                  return GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: MediaQuery.of(context).size.width / 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: 2.5 / 3,
                    ),
                    padding: const EdgeInsets.all(8),
                    itemCount: file.gbgetImages.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          file
                              .findPersonUsingIndexWhere(
                                  file.gbgetImages[index].status.path)
                              .then(
                                (value) => Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        GBImagePageView(imageIndex: value),
                                  ),
                                ),
                              );
                        },
                        child: SingleGridImage(
                          filePath: file.gbgetImages[index].status.path,
                        ),
                      );
                    },
                  );
                } else if (file.itemsData.status == Status.ERROR) {
                  return Center(
                    child: Text(
                      file.itemsData.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        letterSpacing: .5,
                        fontSize: 15,
                      ),
                    ),
                  );
                } else if (file.itemsData.status == Status.LOADING) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Please wait...',
                          style: TextStyle(fontSize: 15),
                        ),
                      )
                    ],
                  );
                } else if (file.gbgetImages.isEmpty) {
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
